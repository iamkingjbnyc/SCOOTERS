// Cloudflare Worker: turns a cart into a Stripe Checkout Session.
//
// The website (checkout.html) POSTs { items, method, customer, address } here.
// This Worker NEVER trusts prices from the browser: it re-reads data/products.json and
// data/store.json from the live site, recomputes every amount, validates the local
// delivery ZIP, and only then asks Stripe for a payment page. It returns { url }.
//
// Setup (see worker/README.md for the click-by-click version):
//   Secrets:  STRIPE_SECRET_KEY   (sk_test_... first, sk_live_... when you go live)
//   Vars:     SITE_ORIGIN         e.g. https://nycatvwarehouse.com
//             ALLOWED_ORIGINS     comma list of sites allowed to call this, e.g. https://nycatvwarehouse.com
//             STRIPE_TAX_RATE_ID  (optional) a Stripe tax rate id (txr_...) to charge sales tax on items

export default {
  async fetch(request, env) {
    const origin = request.headers.get("Origin") || "";
    const allowed = (env.ALLOWED_ORIGINS || env.SITE_ORIGIN || "").split(",").map((s) => s.trim()).filter(Boolean);
    const cors = {
      "Access-Control-Allow-Origin": allowed.includes(origin) ? origin : allowed[0] || "",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
      Vary: "Origin",
    };
    if (request.method === "OPTIONS") return new Response(null, { status: 204, headers: cors });
    if (request.method !== "POST") return json({ error: "Not found" }, 404, cors);
    if (!allowed.includes(origin)) return json({ error: "Origin not allowed" }, 403, cors);

    let order;
    try { order = await request.json(); } catch { return json({ error: "Invalid request." }, 400, cors); }

    try {
      const [catalog, store] = await Promise.all([
        fetch(`${env.SITE_ORIGIN}/data/products.json`, { cf: { cacheTtl: 60 } }).then((r) => r.json()),
        fetch(`${env.SITE_ORIGIN}/data/store.json`, { cf: { cacheTtl: 60 } }).then((r) => r.json()),
      ]);
      const calc = computeOrder(order, catalog.products, store); // throws OrderError on bad input
      const params = buildStripeParams(order, calc, store, env);
      const res = await fetch("https://api.stripe.com/v1/checkout/sessions", {
        method: "POST",
        headers: { Authorization: `Bearer ${env.STRIPE_SECRET_KEY}`, "Content-Type": "application/x-www-form-urlencoded" },
        body: params.toString(),
      });
      const session = await res.json();
      if (!res.ok) {
        console.error("Stripe error", JSON.stringify(session.error || session));
        return json({ error: "We couldn't start payment. Please call us to order." }, 502, cors);
      }
      return json({ url: session.url }, 200, cors);
    } catch (e) {
      if (e instanceof OrderError) return json({ error: e.message }, 400, cors);
      console.error(e);
      return json({ error: "Something went wrong. Please call us to order." }, 500, cors);
    }
  },
};

class OrderError extends Error {}

// Pure function so it can be unit-tested. Mirrors the math in js/script.js.
export function computeOrder(order, products, store) {
  const byId = Object.fromEntries(products.map((p) => [p.id, p]));
  if (!order || !Array.isArray(order.items) || order.items.length === 0) throw new OrderError("Your cart is empty.");
  if (order.items.length > 25) throw new OrderError("Too many items in one order. Please call us.");
  const max = store.maxQtyPerItem || 5;

  const lines = order.items.map((i) => {
    const p = byId[i.id];
    const qty = Number.isInteger(i.qty) ? i.qty : parseInt(i.qty, 10);
    if (!p || !p.inStock || typeof p.price !== "number" || p.price <= 0) throw new OrderError("An item in your cart is no longer available online.");
    if (!(qty >= 1 && qty <= max)) throw new OrderError(`Quantity must be between 1 and ${max}.`);
    return { p, qty, unitCents: Math.round(p.price * 100) };
  });

  const method = order.method;
  let feeCents = 0, feeLabel = "", pickupLoc = null;
  const c = order.customer || {};
  if (!c.name || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(c.email || "") || String(c.phone || "").replace(/\D/g, "").length < 10)
    throw new OrderError("Please enter your name, email and phone.");

  if (method === "pickup") {
    if (!store.pickup.enabled) throw new OrderError("Pickup is not available.");
    feeCents = Math.round((store.pickup.fee || 0) * 100); feeLabel = store.pickup.label;
    const locs = store.pickup.locations || [];
    pickupLoc = locs.find((l) => l.id === order.pickupLocation) || locs[0] || null;
  } else if (method === "local" || method === "ship") {
    const a = order.address || {};
    if (!a.line1 || !a.city || !/^[A-Za-z]{2}$/.test(a.state || "") || !/^\d{5}(-\d{4})?$/.test(a.zip || ""))
      throw new OrderError("Please enter a complete delivery address.");
    if (method === "local") {
      if (!store.localDelivery.enabled) throw new OrderError("Local delivery is not available.");
      const R = store.rules && store.rules.helmetsOnly;
      if (R && lines.every((l) => l.p.category === "helmets") && lines.reduce((n, l) => n + l.unitCents * l.qty, 0) < R.localDeliveryMinSubtotal * 100)
        throw new OrderError("Local delivery is not available for helmet-only orders under $" + R.localDeliveryMinSubtotal + ". Please choose pickup or shipping.");
      const L = store.localDelivery, z5 = a.zip.slice(0, 5);
      const free = L.zips ? L.zips.includes(z5) : L.zipPrefixes.includes(a.zip.slice(0, 3));
      const ext = !free && L.extended && L.extended.enabled && L.extended.zips.includes(z5);
      if (!free && !ext) throw new OrderError("That ZIP is outside our local delivery area.");
      feeCents = Math.round((ext ? L.extended.fee : L.fee) * 100); feeLabel = ext ? L.extended.label : L.label;
    } else {
      if (!store.shipping.enabled) throw new OrderError("Shipping is not available.");
      if (store.shipping.states && !store.shipping.states.includes(a.state.toUpperCase())) throw new OrderError("We ship to the continental U.S. only.");
      if (/^(006|007|008|009|967|968|969|995|996|997|998|999)/.test(a.zip)) throw new OrderError("We ship to the continental U.S. only.");
      const per = store.shipping.perUnitByCategory;
      feeCents = lines.reduce((n, l) => n + Math.round((per[l.p.category] || 0) * 100) * l.qty, 0);
      feeLabel = store.shipping.label;
    }
  } else {
    throw new OrderError("Please choose pickup, local delivery or shipping.");
  }

  const subtotalCents = lines.reduce((n, l) => n + l.unitCents * l.qty, 0);
  const totalCents = subtotalCents + feeCents;
  // Pickup / local delivery: only the deposit is charged online. Shipping: charged in full.
  const dep = store.deposit;
  const HR = store.rules && store.rules.helmetsOnly;
  const helmetsOnly = lines.every((l) => l.p.category === "helmets");
  const isDeposit = !!(dep && dep.methods.includes(method)) && !(HR && HR.noDeposit && helmetsOnly);
  const dueCents = isDeposit ? Math.min(Math.round(dep.amount * 100), totalCents) : totalCents;
  return { pickupLoc, lines, method, feeCents, feeLabel, subtotalCents, totalCents, isDeposit, dueCents, balanceCents: totalCents - dueCents };
}

export function buildStripeParams(order, calc, store, env) {
  const q = new URLSearchParams();
  const site = env.SITE_ORIGIN;
  q.set("mode", "payment");
  q.set("success_url", `${site}/order-complete.html?session_id={CHECKOUT_SESSION_ID}`);
  q.set("cancel_url", `${site}/checkout.html`);
  q.set("customer_email", order.customer.email);
  const usd = (c) => "$" + (c / 100).toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const itemsText = calc.lines.map((l) => `${l.qty}x ${l.p.name}`).join("; ");
  if (calc.isDeposit) {
    // One deposit line. The balance is collected in person at pickup/delivery.
    const where = calc.method === "pickup" ? "pickup" : "delivery";
    const at = calc.pickupLoc ? ` (${calc.pickupLoc.name})` : "";
    q.set("line_items[0][quantity]", "1");
    q.set("line_items[0][price_data][currency]", "usd");
    q.set("line_items[0][price_data][unit_amount]", String(calc.dueCents));
    q.set("line_items[0][price_data][product_data][name]", `Deposit: ${itemsText}`.slice(0, 200));
    q.set("line_items[0][price_data][product_data][description]",
      `Non-refundable deposit (covers assembly and/or delivery). Order total ${usd(calc.totalCents)}. Balance of ${usd(calc.balanceCents)} is due at ${where}${at}.`);
  } else {
    calc.lines.forEach((l, i) => {
      q.set(`line_items[${i}][quantity]`, String(l.qty));
      q.set(`line_items[${i}][price_data][currency]`, "usd");
      q.set(`line_items[${i}][price_data][unit_amount]`, String(l.unitCents));
      q.set(`line_items[${i}][price_data][product_data][name]`, l.p.name);
      q.set(`line_items[${i}][price_data][product_data][metadata][product_id]`, l.p.id);
      if (env.STRIPE_TAX_RATE_ID) q.set(`line_items[${i}][tax_rates][0]`, env.STRIPE_TAX_RATE_ID);
    });
    q.set("shipping_options[0][shipping_rate_data][type]", "fixed_amount");
    q.set("shipping_options[0][shipping_rate_data][display_name]", calc.feeLabel);
    q.set("shipping_options[0][shipping_rate_data][fixed_amount][amount]", String(calc.feeCents));
    q.set("shipping_options[0][shipping_rate_data][fixed_amount][currency]", "usd");
  }

  if (calc.method !== "pickup") {
    const a = order.address;
    q.set("payment_intent_data[shipping][name]", order.customer.name);
    q.set("payment_intent_data[shipping][phone]", order.customer.phone);
    q.set("payment_intent_data[shipping][address][line1]", a.line1);
    if (a.line2) q.set("payment_intent_data[shipping][address][line2]", a.line2);
    q.set("payment_intent_data[shipping][address][city]", a.city);
    q.set("payment_intent_data[shipping][address][state]", a.state.toUpperCase());
    q.set("payment_intent_data[shipping][address][postal_code]", a.zip);
    q.set("payment_intent_data[shipping][address][country]", "US");
  }
  const meta = {
    fulfillment: calc.method,
    pickup_location: calc.pickupLoc ? `${calc.pickupLoc.name} - ${calc.pickupLoc.address}` : "",
    customer_name: order.customer.name,
    customer_phone: order.customer.phone,
    notes: (order.customer.notes || "").slice(0, 400),
    items: itemsText.slice(0, 480),
    order_total: usd(calc.totalCents),
    paid_today: usd(calc.dueCents),
    balance_due: usd(calc.balanceCents),
  };
  for (const [k, v] of Object.entries(meta)) { q.set(`metadata[${k}]`, v); q.set(`payment_intent_data[metadata][${k}]`, v); }
  return q;
}

function json(body, status, headers) {
  return new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json", ...headers } });
}

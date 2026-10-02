// Cloudflare Worker: receives Stripe webhook events and posts a Slack message
// on checkout.session.completed (i.e. a deposit or full payment succeeded).
//
// Deploy: Cloudflare Dashboard -> Workers & Pages -> Create Worker -> paste this file.
// Then set two encrypted environment variables on the Worker (Settings -> Variables):
//   STRIPE_WEBHOOK_SECRET  -> the "Signing secret" Stripe gives you when you create
//                             the webhook endpoint (starts with whsec_...)
//   SLACK_WEBHOOK_URL      -> your Slack "Incoming Webhook" URL
//
// After deploying, the Worker gets a URL like:
//   https://stripe-webhook.<your-subdomain>.workers.dev
// Give that URL to Claude (or paste it into Stripe Dashboard -> Developers -> Webhooks
// -> Add endpoint, event: checkout.session.completed) to finish wiring it up.

export default {
  async fetch(request, env) {
    if (request.method !== "POST") {
      return new Response("Not found", { status: 404 });
    }

    const signature = request.headers.get("stripe-signature");
    const body = await request.text();

    const isValid = await verifyStripeSignature(body, signature, env.STRIPE_WEBHOOK_SECRET);
    if (!isValid) {
      return new Response("Invalid signature", { status: 400 });
    }

    const event = JSON.parse(body);

    if (event.type === "checkout.session.completed") {
      const session = event.data.object;
      const amount = (session.amount_total / 100).toFixed(2);
      const email = session.customer_details?.email || "no email";
      const productName = session.metadata?.product_name || session.line_items?.data?.[0]?.description || "item";

      const text = `New payment received: $${amount} from ${email} (session ${session.id}). Check Stripe Dashboard for details.`;

      await fetch(env.SLACK_WEBHOOK_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text }),
      });
    }

    return new Response("ok", { status: 200 });
  },
};

// Verifies the Stripe-Signature header using Web Crypto (Cloudflare Workers have no Node crypto).
async function verifyStripeSignature(payload, signatureHeader, secret) {
  if (!signatureHeader || !secret) return false;

  const parts = Object.fromEntries(
    signatureHeader.split(",").map((pair) => pair.split("="))
  );
  const timestamp = parts.t;
  const expectedSig = parts.v1;
  if (!timestamp || !expectedSig) return false;

  const signedPayload = `${timestamp}.${payload}`;
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const signatureBuffer = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(signedPayload));
  const computedSig = [...new Uint8Array(signatureBuffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");

  return computedSig === expectedSig;
}

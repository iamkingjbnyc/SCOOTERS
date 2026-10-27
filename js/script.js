/* NYC ATV Warehouse — storefront script: cart, search, product buying, checkout */
(function () {
  'use strict';

  var BASE = document.body.getAttribute('data-base') || '';
  var CART_KEY = 'nycatv_cart_v1';
  var ORDER_KEY = 'nycatv_preview_order_v1';
  var CAT_LABEL = { scooters: 'Scooters', atvs: 'ATVs', dirtbikes: 'Dirt Bikes', gokarts: 'Go-Karts', utvs: 'UTVs', ebikes: 'E-Bikes', helmets: 'Helmets' };

  var CATALOG = [], STORE = null, BY_ID = {};

  /* ---------- helpers ---------- */
  function $(s, r) { return (r || document).querySelector(s); }
  function $$(s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); }
  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function money(n) {
    var hasCents = Math.round(n * 100) % 100 !== 0;
    return '$' + Number(n).toLocaleString('en-US', { minimumFractionDigits: hasCents ? 2 : 0, maximumFractionDigits: 2 });
  }
  function img(p) { return /^https?:/.test(p.image) ? p.image : BASE + p.image; }
  function buyable(p) { return p && p.inStock && typeof p.price === 'number' && p.price > 0; }

  /* ---------- cart state ---------- */
  function loadCart() {
    try {
      var raw = JSON.parse(localStorage.getItem(CART_KEY) || '[]');
      return Array.isArray(raw) ? raw.filter(function (l) { return l && l.id && l.qty > 0; }) : [];
    } catch (e) { return []; }
  }
  var cart = loadCart();
  function saveCart() { try { localStorage.setItem(CART_KEY, JSON.stringify(cart)); } catch (e) { /* storage blocked */ } }
  function maxQty() { return (STORE && STORE.maxQtyPerItem) || 5; }
  function cartLines() {
    return cart.map(function (l) { return { p: BY_ID[l.id], qty: l.qty }; }).filter(function (l) { return buyable(l.p); });
  }
  function cartCount() { return cartLines().reduce(function (n, l) { return n + l.qty; }, 0); }
  function subtotal() { return cartLines().reduce(function (n, l) { return n + l.p.price * l.qty; }, 0); }

  function addToCart(id, qty) {
    var p = BY_ID[id];
    if (!buyable(p)) return false;
    qty = Math.max(1, parseInt(qty, 10) || 1);
    var line = cart.filter(function (l) { return l.id === id; })[0];
    if (line) line.qty = Math.min(maxQty(), line.qty + qty); else cart.push({ id: id, qty: Math.min(maxQty(), qty) });
    saveCart(); renderCartUI(); return true;
  }
  function setQty(id, qty) {
    qty = parseInt(qty, 10) || 1;
    cart.forEach(function (l) { if (l.id === id) l.qty = Math.max(1, Math.min(maxQty(), qty)); });
    saveCart(); renderCartUI();
  }
  function removeFromCart(id) { cart = cart.filter(function (l) { return l.id !== id; }); saveCart(); renderCartUI(); }
  function clearCart() { cart = []; saveCart(); renderCartUI(); }

  /* ---------- fulfillment math (checkout worker mirrors this) ---------- */
  function shippingCost(lines) {
    var per = STORE.shipping.perUnitByCategory || {};
    return lines.reduce(function (n, l) { return n + (per[l.p.category] || 0) * l.qty; }, 0);
  }
  function zipTier(zip) {
    var z = String(zip || '').replace(/\D/g, '');
    if (z.length < 5) return null;
    var L = STORE.localDelivery, z5 = z.slice(0, 5);
    if (L.zips ? L.zips.indexOf(z5) !== -1 : L.zipPrefixes.indexOf(z.slice(0, 3)) !== -1) return 'free';
    if (L.extended && L.extended.enabled && L.extended.zips.indexOf(z5) !== -1) return 'ext';
    return 'out';
  }
  function zipInLocalZone(zip) { var t = zipTier(zip); return t === null ? null : t !== 'out'; }
  var currentZip = '';
  function helmetsOnly(lines) { return !!lines && lines.length > 0 && lines.every(function (l) { return l.p.category === 'helmets'; }); }
  function helmetRules() { return (STORE.rules && STORE.rules.helmetsOnly) || null; }
  var payFullFlag = false; // customer chose to pay the whole amount today (needed to finance it with Affirm)
  function depositEligible(method, lines) {
    var R = helmetRules();
    if (R && R.noDeposit && helmetsOnly(lines)) return false;
    return !!(STORE.deposit && STORE.deposit.methods.indexOf(method) !== -1);
  }
  function isDeposit(method, lines) { return depositEligible(method, lines) && !payFullFlag; }
  function dueToday(method, total, lines) { return isDeposit(method, lines) ? Math.min(STORE.deposit.amount, total) : total; }
  function localAllowed(lines, sub) { var R = helmetRules(); return !(R && helmetsOnly(lines) && sub < R.localDeliveryMinSubtotal); }
  function feeFor(method, lines) {
    if (method === 'pickup') return STORE.pickup.fee || 0;
    if (method === 'local') return zipTier(currentZip) === 'ext' ? STORE.localDelivery.extended.fee : STORE.localDelivery.fee;
    return shippingCost(lines);
  }

  /* ---------- icons ---------- */
  var ICON = {
    truck: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7h11v9H3zM14 10h4l3 3v3h-7z"/><circle cx="7.5" cy="17.5" r="1.8"/><circle cx="17.5" cy="17.5" r="1.8"/></svg>',
    box: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7.5L12 3l9 4.5v9L12 21l-9-4.5z"/><path d="M3 7.5l9 4.5 9-4.5M12 12v9"/></svg>',
    pin: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s7-6.3 7-12a7 7 0 10-14 0c0 5.7 7 12 7 12z"/><circle cx="12" cy="10" r="2.5"/></svg>',
    bag: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M5 8h14l-1 12H6zM9 8V6a3 3 0 016 0v2"/></svg>',
    x: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg>',
    check: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6L9 17l-5-5"/></svg>'
  };

  /* ---------- cart drawer ---------- */
  var drawer, overlay, toastEl, toastTimer;
  function buildDrawer() {
    overlay = document.createElement('div'); overlay.className = 'drawer-overlay';
    drawer = document.createElement('aside'); drawer.className = 'cart-drawer';
    drawer.setAttribute('aria-label', 'Shopping cart'); drawer.setAttribute('aria-hidden', 'true');
    drawer.innerHTML = '<div class="drawer-head"><h3>Your cart</h3><button class="icon-btn" data-close aria-label="Close cart">' + ICON.x + '</button></div>' +
      '<div class="drawer-body" id="drawerBody"></div><div class="drawer-foot" id="drawerFoot"></div>';
    toastEl = document.createElement('div'); toastEl.className = 'toast'; toastEl.setAttribute('role', 'status');
    document.body.appendChild(overlay); document.body.appendChild(drawer); document.body.appendChild(toastEl);
    overlay.addEventListener('click', closeDrawer);
    drawer.addEventListener('click', function (e) {
      if (e.target.closest('[data-close]')) return closeDrawer();
      var rm = e.target.closest('[data-remove]'); if (rm) return removeFromCart(rm.getAttribute('data-remove'));
      var dec = e.target.closest('[data-dec]'); if (dec) { var l = cart.filter(function (x) { return x.id === dec.getAttribute('data-dec'); })[0]; return l && setQty(l.id, l.qty - 1); }
      var inc = e.target.closest('[data-inc]'); if (inc) { var m = cart.filter(function (x) { return x.id === inc.getAttribute('data-inc'); })[0]; return m && setQty(m.id, m.qty + 1); }
    });
    drawer.addEventListener('change', function (e) {
      if (e.target.matches('[data-qty-input]')) setQty(e.target.getAttribute('data-qty-input'), e.target.value);
    });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeDrawer(); });
  }
  function openDrawer() {
    drawer.classList.add('open'); overlay.classList.add('open'); drawer.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
  }
  function closeDrawer() {
    if (!drawer) return;
    drawer.classList.remove('open'); overlay.classList.remove('open'); drawer.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
  }
  function toast(html) {
    toastEl.innerHTML = html; toastEl.classList.add('show');
    clearTimeout(toastTimer); toastTimer = setTimeout(function () { toastEl.classList.remove('show'); }, 3800);
  }

  function renderCartUI() {
    var n = cartCount();
    $$('.cart-count').forEach(function (el) { el.textContent = n; });
    if (!drawer) return;
    var lines = cartLines(), body = $('#drawerBody'), foot = $('#drawerFoot');
    if (!lines.length) {
      body.innerHTML = '<div class="drawer-empty">' + ICON.bag + '<h4>Your cart is empty</h4><p>Find a ride you love and add it to your cart.</p></div>';
      foot.innerHTML = '<a class="btn btn-primary btn-block" href="' + BASE + 'index.html#shop">Start shopping</a>';
      return;
    }
    body.innerHTML = lines.map(function (l) {
      var p = l.p;
      return '<div class="cart-line"><a href="' + BASE + esc(p.url) + '"><img src="' + esc(img(p)) + '" alt="' + esc(p.name) + '"></a><div>' +
        '<div class="cl-cat">' + esc(CAT_LABEL[p.category] || '') + '</div><h4><a href="' + BASE + esc(p.url) + '">' + esc(p.name) + '</a></h4>' +
        '<div class="cl-row"><div class="qty"><button type="button" data-dec="' + esc(p.id) + '" aria-label="Decrease quantity">&minus;</button>' +
        '<input type="number" min="1" max="' + maxQty() + '" value="' + l.qty + '" data-qty-input="' + esc(p.id) + '" aria-label="Quantity">' +
        '<button type="button" data-inc="' + esc(p.id) + '" aria-label="Increase quantity">+</button></div>' +
        '<span class="cl-price">' + money(p.price * l.qty) + '</span></div>' +
        '<button class="cl-remove" type="button" data-remove="' + esc(p.id) + '">Remove</button></div></div>';
    }).join('');
    foot.innerHTML = '<div class="drawer-total"><span>Subtotal</span><strong>' + money(subtotal()) + '</strong></div>' +
      '<p class="drawer-note">Choose shipping, local delivery or free pickup at checkout.</p>' +
      '<a class="btn btn-primary btn-block btn-lg" href="' + BASE + 'checkout.html">Checkout</a>' +
      '<button class="btn btn-outline btn-block" type="button" data-close>Continue shopping</button>';
  }

  function flashAdded(p) {
    var cb = $('.cart-btn'); if (cb) { cb.classList.remove('bump'); void cb.offsetWidth; cb.classList.add('bump'); }
    toast(esc(p.name) + ' added to cart <a href="#" data-open-cart>View cart</a>');
  }

  /* ---------- header: search, nav ---------- */
  function initHeader() {
    var yr = $('#year'); if (yr) yr.textContent = new Date().getFullYear();
    var t = $('#navToggle'); if (t) t.addEventListener('click', function () { document.body.classList.toggle('nav-open'); });

    $$('[data-cart-open], .cart-btn').forEach(function (b) { b.addEventListener('click', function (e) { e.preventDefault(); openDrawer(); }); });
    document.addEventListener('click', function (e) {
      var o = e.target.closest('[data-open-cart]'); if (o) { e.preventDefault(); openDrawer(); }
      var link = e.target.closest('a[href^="tel:"]');
      if (link && typeof gtag === 'function') gtag('event', 'conversion', { send_to: 'AW-11412137626/Ro8TCN-A0Y4dEJrN3cEq' });
    });

    var input = $('#siteSearch'), box = $('#searchResults');
    if (!input || !box) return;
    var active = -1, hits = [];
    function render(q) {
      q = q.trim().toLowerCase();
      if (q.length < 2) { box.classList.remove('open'); box.innerHTML = ''; hits = []; return; }
      var terms = q.split(/\s+/);
      hits = CATALOG.filter(function (p) {
        var hay = (p.name + ' ' + (CAT_LABEL[p.category] || '') + ' ' + p.category).toLowerCase();
        return terms.every(function (t) { return hay.indexOf(t) !== -1; });
      }).slice(0, 8);
      active = -1;
      box.innerHTML = hits.length ? hits.map(function (p, i) {
        return '<a class="search-hit" data-i="' + i + '" href="' + BASE + esc(p.url) + '"><img src="' + esc(img(p)) + '" alt=""><span><strong>' + esc(p.name) + '</strong><small>' + esc(CAT_LABEL[p.category]) + '</small></span><span class="sh-price">' + (buyable(p) ? money(p.price) : 'Call') + '</span></a>';
      }).join('') : '<div class="search-empty">No matches for &ldquo;' + esc(q) + '&rdquo;. Try a brand or category, or call us at ' + esc(STORE ? STORE.business.phone : '') + '.</div>';
      box.classList.add('open');
    }
    input.addEventListener('input', function () { render(input.value); });
    input.addEventListener('focus', function () { if (input.value.length > 1) render(input.value); });
    input.addEventListener('keydown', function (e) {
      var items = $$('.search-hit', box);
      if (e.key === 'ArrowDown') { e.preventDefault(); active = Math.min(items.length - 1, active + 1); }
      else if (e.key === 'ArrowUp') { e.preventDefault(); active = Math.max(0, active - 1); }
      else if (e.key === 'Enter') { e.preventDefault(); var tgt = items[active] || items[0]; if (tgt) window.location.href = tgt.getAttribute('href'); return; }
      else if (e.key === 'Escape') { box.classList.remove('open'); return; }
      else return;
      items.forEach(function (el, i) { el.classList.toggle('active', i === active); });
    });
    document.addEventListener('click', function (e) { if (!e.target.closest('.search')) box.classList.remove('open'); });
    $('.search').addEventListener('submit', function (e) { e.preventDefault(); });
  }

  /* ---------- product cards & PDP ---------- */
  function initBuyButtons() {
    document.addEventListener('click', function (e) {
      var add = e.target.closest('[data-add]');
      if (add) {
        e.preventDefault();
        var id = add.getAttribute('data-add'), qtyEl = $('#pdpQty'), q = (add.hasAttribute('data-use-qty') && qtyEl) ? qtyEl.value : 1;
        if (addToCart(id, q)) { flashAdded(BY_ID[id]); }
        return;
      }
      var buy = e.target.closest('[data-buy]');
      if (buy) {
        e.preventDefault();
        var bid = buy.getAttribute('data-buy'), qe = $('#pdpQty');
        if (addToCart(bid, (buy.hasAttribute('data-use-qty') && qe) ? qe.value : 1)) window.location.href = BASE + 'checkout.html';
      }
    });
    var qty = $('#pdpQty');
    if (qty) {
      var clamp = function () { qty.value = Math.max(1, Math.min(maxQty(), parseInt(qty.value, 10) || 1)); };
      qty.addEventListener('change', clamp);
      $('#pdpDec').addEventListener('click', function () { qty.value = (parseInt(qty.value, 10) || 1) - 1; clamp(); });
      $('#pdpInc').addEventListener('click', function () { qty.value = (parseInt(qty.value, 10) || 1) + 1; clamp(); });
    }
    $$('.gallery-thumbs .thumb').forEach(function (t) {
      t.addEventListener('click', function () {
        var main = $('#mainPhoto'); if (main) main.src = t.src;
        $$('.gallery-thumbs .thumb').forEach(function (x) { x.classList.remove('active'); });
        t.classList.add('active');
      });
    });
  }

  function cardHTML(p) {
    var sold = !p.inStock;
    var price = buyable(p) ? '<p class="bike-price">' + money(p.price) + '</p>' : sold ? '<p class="bike-price call">Sold out</p>' : '<p class="bike-price call">Call for pricing</p>';
    var actions = buyable(p)
      ? '<button class="btn btn-primary" type="button" data-add="' + esc(p.id) + '">Add to cart</button>'
      : sold ? '<button class="btn btn-dark" type="button" disabled>Sold out</button>'
      : '<a class="btn btn-dark" href="' + esc(STORE.business.phoneHref) + '">Call to order</a>';
    return '<div class="bike-card" data-id="' + esc(p.id) + '"><a href="' + BASE + esc(p.url) + '"><img loading="lazy" src="' + esc(img(p)) + '" alt="' + esc(p.name) + '"></a>' +
      '<div class="bike-card-body"><div class="bike-card-cat">' + esc(CAT_LABEL[p.category]) + '</div><h3><a href="' + BASE + esc(p.url) + '">' + esc(p.name) + '</a></h3>' + price +
      '<div class="card-actions">' + actions + '</div></div></div>';
  }

  function initRelated() {
    var host = $('#related'); if (!host) return;
    var id = host.getAttribute('data-id'), cat = host.getAttribute('data-cat');
    var pool = CATALOG.filter(function (p) { return p.category === cat && p.id !== id; });
    var start = Math.max(0, CATALOG.filter(function (p) { return p.category === cat; }).findIndex(function (p) { return p.id === id; }));
    var picks = pool.slice(start % Math.max(pool.length, 1)).concat(pool).slice(0, 4);
    if (!picks.length) { host.style.display = 'none'; return; }
    $('.bike-grid', host).innerHTML = picks.map(cardHTML).join('');
  }

  function initFeatured() {
    $$('[data-featured]').forEach(function (host) {
      var ids = host.getAttribute('data-featured').split(',');
      host.innerHTML = ids.map(function (i) { return BY_ID[i.trim()]; }).filter(Boolean).map(cardHTML).join('');
    });
  }

  function initSort() {
    var sel = $('#sortSel'), grid = $('#productGrid'); if (!sel || !grid) return;
    var cards = $$('.bike-card', grid);
    cards.forEach(function (c, i) { c.setAttribute('data-order', i); });
    function val(c) { var p = BY_ID[c.getAttribute('data-id')]; return p && buyable(p) ? p.price : Infinity; }
    sel.addEventListener('change', function () {
      var v = sel.value, sorted = cards.slice();
      if (v === 'low') sorted.sort(function (a, b) { return val(a) - val(b); });
      else if (v === 'high') sorted.sort(function (a, b) { return (val(b) === Infinity ? -1 : val(b)) - (val(a) === Infinity ? -1 : val(a)); });
      else if (v === 'az') sorted.sort(function (a, b) { return BY_ID[a.getAttribute('data-id')].name.localeCompare(BY_ID[b.getAttribute('data-id')].name); });
      else sorted.sort(function (a, b) { return a.getAttribute('data-order') - b.getAttribute('data-order'); });
      sorted.forEach(function (c) { grid.appendChild(c); });
    });
  }

  function initStoreText() {
    $$('[data-store]').forEach(function (el) {
      var path = el.getAttribute('data-store').split('.'), v = STORE;
      path.forEach(function (k) { v = v && v[k]; });
      if (v == null) return;
      el.textContent = (typeof v === 'number') ? (v === 0 ? 'Free' : money(v)) : v;
    });
    $$('[data-ship-rate]').forEach(function (el) {
      var v = STORE.shipping.perUnitByCategory[el.getAttribute('data-ship-rate')];
      if (v != null) el.textContent = v === 0 ? 'Free' : money(v);
    });
  }

  function initPreviewRibbon() {
    if (!STORE.showPreviewBanner || STORE.checkoutEndpoint) return;
    var r = document.createElement('div'); r.className = 'preview-ribbon';
    r.textContent = 'PREVIEW — online checkout is not live yet. Nothing on this site charges a card.';
    document.body.insertBefore(r, document.body.firstChild);
  }

  /* ---------- checkout page ---------- */
  function initCheckout() {
    var app = $('#checkoutApp'); if (!app) return;
    var lines = cartLines();
    if (!lines.length) {
      app.innerHTML = '<div class="container"><div class="empty-state"><h1>Your cart is empty</h1><p>Add a ride to your cart to check out.</p><a class="btn btn-primary btn-lg" href="' + BASE + 'index.html#shop">Shop now</a></div></div>';
      return;
    }
    var S = STORE, methods = [];
    if (S.pickup.enabled) methods.push('pickup');
    if (S.localDelivery.enabled) methods.push('local');
    if (S.shipping.enabled) methods.push('ship');
    function pickupLoc() { var el = document.querySelector('input[name=ploc]:checked'); var id = el ? el.value : S.pickup.locations[0].id; return S.pickup.locations.filter(function (L) { return L.id === id; })[0] || S.pickup.locations[0]; }
    var state = { method: S.pickup.enabled ? 'pickup' : methods[0] };

    var optHTML = {
      pickup: { ic: ICON.pin, t: S.pickup.label },
      local: { ic: ICON.truck, t: S.localDelivery.label },
      ship: { ic: ICON.box, t: S.shipping.label }
    };
    function descFor(m) {
      var dep = isDeposit(m, lines), amt = money(S.deposit.amount);
      if (m === 'pickup') return S.pickup.detail + (dep ? ' ' + amt + ' non-refundable deposit now, balance at pickup.' : ' Pay in full online.');
      if (m === 'local') {
        if (!localAllowed(lines, subtotal())) return 'Not available for helmet-only orders under ' + money(helmetRules().localDeliveryMinSubtotal) + '. Add a vehicle or choose pickup or shipping.';
        return S.localDelivery.detail + (dep ? ' ' + amt + ' non-refundable deposit now, balance on delivery.' : ' Pay in full online.');
      }
      return S.shipping.detail + ' Paid in full online.';
    }
    function methodHTML(m) {
      var o = optHTML[m];
      return '<label class="method"><input type="radio" name="method" value="' + m + '"' + (state.method === m ? ' checked' : '') + '><span class="m-body"><span class="m-ic">' + o.ic + '</span><span><strong>' + esc(o.t) + '</strong><span class="m-d" data-md="' + m + '"></span></span><span class="m-price" data-mprice="' + m + '"></span></span></label>';
    }
    function fieldHTML(id, label, type, extra) {
      return '<div class="field" data-f="' + id + '"><label for="f_' + id + '">' + label + '</label><input id="f_' + id + '" name="' + id + '" type="' + (type || 'text') + '" ' + (extra || '') + '><div class="err"></div></div>';
    }
    app.innerHTML = '<div class="container"><h1 class="section-title" style="margin-bottom:22px">Checkout</h1><div class="checkout-grid"><div>' +
      '<form id="coForm" novalidate>' +
      '<div class="co-card"><h2><span class="n">1</span>How do you want to get it?</h2>' + methods.map(methodHTML).join('') +
      '<div class="pickup-box" id="pickupBox"><strong>Choose a pickup location:</strong>' + S.pickup.locations.map(function (L, i) {
        return '<label style="display:flex;gap:10px;align-items:flex-start;margin-top:10px;cursor:pointer;color:var(--ink)"><input type="radio" name="ploc" value="' + L.id + '"' + (i === 0 ? ' checked' : '') + ' style="margin-top:4px"><span><strong>' + esc(L.name) + '</strong><br>' + esc(L.address) + '<br><span style="color:var(--text-muted)">' + (L.hours ? esc(L.hours) : 'Call ' + esc(S.business.phone) + ' to schedule pickup') + '</span></span></label>';
      }).join('') + '<div style="margin-top:10px">We&rsquo;ll call or email you when your order is ready.</div></div>' +
      '</div>' +
      '<div class="co-card"><h2><span class="n">2</span>Your details</h2>' +
      '<div class="grid-2">' + fieldHTML('name', 'Full name', 'text', 'autocomplete="name" required') + fieldHTML('phone', 'Phone', 'tel', 'autocomplete="tel" required') + '</div>' +
      fieldHTML('email', 'Email', 'email', 'autocomplete="email" required') +
      '<div class="addr-block" id="addrBlock"><h3 style="font-size:1.25rem;margin:8px 0 12px">Delivery address</h3>' +
      fieldHTML('address1', 'Street address', 'text', 'autocomplete="address-line1"') + fieldHTML('address2', 'Apt / suite (optional)', 'text', 'autocomplete="address-line2"') +
      '<div class="grid-3">' + fieldHTML('city', 'City', 'text', 'autocomplete="address-level2"') + fieldHTML('state', 'State', 'text', 'autocomplete="address-level1" maxlength="2" style="text-transform:uppercase"') + fieldHTML('zip', 'ZIP', 'text', 'autocomplete="postal-code" inputmode="numeric" maxlength="10"') + '</div>' +
      '<div class="zone-msg" id="zoneMsg"></div></div>' +
      '<div class="field"><label for="f_notes">Order notes (optional)</label><textarea id="f_notes" name="notes" rows="3" placeholder="Anything we should know?" style="width:100%;border:1.5px solid var(--line);border-radius:8px;padding:12px 14px;font:inherit"></textarea></div>' +
      '</div>' +
      '<div class="co-card"><h2><span class="n">3</span>Payment</h2><p style="color:var(--text-muted);font-size:.93rem" id="payNote"></p>' +
      '<div class="assembly-note" id="assemblyNote" style="display:none"><span class="ic">' + ICON.box + '</span><div><strong>' + esc(S.assembly.title) + '</strong><span>' + esc(S.assembly.text) + '</span></div></div>' +
      '<div id="payFullWrap" style="display:none;margin-top:12px"><label style="display:flex;gap:10px;align-items:flex-start;font-weight:600;font-size:.9rem;cursor:pointer"><input type="checkbox" id="f_payFull" style="margin-top:3px;width:18px;height:18px"><span>Pay the full amount today instead of a deposit. <span style="font-weight:400;color:var(--text-muted)">Choose this to finance your whole order with Affirm.</span></span></label></div>' +
      '<div class="field" data-f="depositOk" id="depositOkWrap" style="display:none;margin-top:12px"><label style="display:flex;gap:10px;align-items:flex-start;font-weight:600;font-size:.9rem;cursor:pointer"><input type="checkbox" id="f_depositOk" style="margin-top:3px;width:18px;height:18px"><span>I understand the ' + money(S.deposit.amount) + ' deposit is non-refundable and covers assembly and/or delivery charges.</span></label><div class="err"></div></div>' +
      '<button class="btn btn-primary btn-block btn-lg" id="placeBtn2" type="button" style="margin-top:14px">Place order</button><p class="co-fine" style="margin-top:10px">By placing your order you agree to our <a href="terms.html" target="_blank" rel="noopener">terms of service</a>, <a href="returns.html" target="_blank" rel="noopener">return policy</a> and <a href="privacy.html" target="_blank" rel="noopener">privacy policy</a>.</p><div id="coError2" class="zone-msg bad" role="alert"></div></div>' +
      '</form></div>' +
      '<aside class="summary"><div class="co-card"><h2 style="margin-bottom:6px">Order summary</h2><div id="sumLines"></div><div class="sum-rows" id="sumRows"></div>' +
      '<div class="co-actions"><div class="assembly-note" id="assemblyNote2" style="display:none;margin:0 0 12px"><span class="ic">' + ICON.box + '</span><div><strong>' + esc(S.assembly.title) + '</strong><span>' + esc(S.assembly.text) + '</span></div></div><button class="btn btn-primary btn-block btn-lg" id="placeBtn" type="button">Place order</button><p class="co-fine" id="coFine"></p>' +
      '<div id="coError" class="zone-msg bad" role="alert"></div></div></div></aside></div></div>';

    var payNote = $('#payNote'), fine = $('#coFine');
    if (S.checkoutEndpoint) { fine.textContent = 'You’ll enter your payment on Stripe’s secure payment page (choose Affirm there to finance). We never see your card number.'; }
    else if (S.orderRequestEndpoint) {
      fine.textContent = 'You are not charged until we have confirmed your order with you.';
      $('#placeBtn').textContent = 'Send my order';
    } else { payNote.textContent = 'Preview mode: payments are not connected yet, so no card is requested and nothing is charged.'; fine.textContent = 'Preview only — clicking Place order shows what the confirmation looks like.'; }

    function totals() {
      var fee = feeFor(state.method, lines);
      var total = subtotal() + fee, due = dueToday(state.method, total, lines);
      return { sub: subtotal(), fee: fee, total: total, due: due, balance: total - due };
    }
    function render() {
      lines = cartLines();
      if (!lines.length) { initCheckoutEmpty(); return; }
      $('#sumLines').innerHTML = lines.map(function (l) {
        return '<div class="sum-line"><img src="' + esc(img(l.p)) + '" alt=""><div><strong>' + esc(l.p.name) + '</strong><small>Qty ' + l.qty + '</small></div><span>' + money(l.p.price * l.qty) + '</span></div>';
      }).join('');
      if (state.method === 'local' && !localAllowed(lines, subtotal())) { state.method = S.pickup.enabled ? 'pickup' : 'ship'; var rb = document.querySelector('input[name=method][value=' + state.method + ']'); if (rb) rb.checked = true; }
      methods.forEach(function (m) {
        var d = $('[data-md="' + m + '"]'); if (d) d.textContent = descFor(m);
        if (m === 'local') { var ok = localAllowed(lines, subtotal()), inp = document.querySelector('input[name=method][value=local]'); if (inp) { inp.disabled = !ok; inp.closest('label').style.opacity = ok ? '' : '.55'; } }
      });
      var t = totals();
      var feeLbl = t.fee === 0 ? '<span class="free">Free</span>' : money(t.fee);
      var label = state.method === 'pickup' ? 'Pickup' : state.method === 'local' ? 'Local delivery' : 'Shipping';
      $('#sumRows').innerHTML = '<div><span>Subtotal</span><span>' + money(t.sub) + '</span></div><div><span>' + label + '</span><span>' + feeLbl + '</span></div>' +
        '<div><span>Sales tax</span><span style="color:var(--text-muted);font-size:.85rem">' + esc(S.tax.note) + '</span></div><div class="t"><span>Order total</span><span>' + money(t.total) + '</span></div>' +
        '<div class="due"><span>' + (S.checkoutEndpoint ? 'Due today' : 'Due when we confirm') + (t.balance ? ' (deposit)' : '') + '</span><span>' + money(t.due) + '</span></div>' +
        (t.balance ? '<div class="bal"><span>Balance due at ' + (state.method === 'pickup' ? 'pickup' : 'delivery') + '</span><span>' + money(t.balance) + '</span></div>' : '');
      var pn = $('#payNote'), pb = $('#placeBtn');
      var label2 = null;
      if (S.checkoutEndpoint) {
        pn.textContent = t.balance ? 'Pay a ' + money(t.due) + ' deposit securely online to reserve your order. ' + S.deposit.policyText + ' The remaining ' + money(t.balance) + ' is due at ' + (state.method === 'pickup' ? 'pickup' : 'delivery') + '. Financing available: to finance your whole order, check \u201cPay the full amount today\u201d below, then choose Affirm on the payment page.' : (state.method === 'ship' ? 'Shipped orders are paid in full online. ' : '') + 'Pay the full ' + money(t.due) + ' securely online. Financing available: choose Affirm on the payment page to pay over time.';
        pb.textContent = t.balance ? 'Pay ' + money(t.due) + ' deposit' : 'Pay ' + money(t.due);
      } else if (S.orderRequestEndpoint) {
        pn.textContent = 'No card is needed online. Send us your order and we\u2019ll contact you within 1 business day to confirm the details and take ' + (t.balance ? 'your ' + money(t.due) + ' deposit (the remaining ' + money(t.balance) + ' is due at ' + (state.method === 'pickup' ? 'pickup' : 'delivery') + ')' : 'payment') + (state.method === 'ship' ? ', including the final shipping cost' : '') + '.';
      }
      $('#placeBtn2').textContent = pb.textContent;
      methods.forEach(function (m) {
        var el = $('[data-mprice="' + m + '"]'); if (!el) return;
        var f = feeFor(m, lines); el.textContent = f === 0 ? (m === 'local' && S.localDelivery.extended ? 'Free / $' + S.localDelivery.extended.fee : 'Free') : money(f); el.className = 'm-price' + (f === 0 ? ' free' : '');
      });
      $('#addrBlock').classList.toggle('show', state.method !== 'pickup');
      $('#depositOkWrap').style.display = (t.balance ? 'block' : 'none');
      $('#payFullWrap').style.display = (S.checkoutEndpoint && depositEligible(state.method, lines)) ? 'block' : 'none';
      var needsAsm = state.method === 'ship' && lines.some(function (l) { return l.p.category !== 'helmets'; });
      $('#assemblyNote').style.display = needsAsm ? 'flex' : 'none';
      $('#assemblyNote2').style.display = needsAsm ? 'flex' : 'none';
      $('#pickupBox').classList.toggle('show', state.method === 'pickup');
      checkZone();
    }
    function initCheckoutEmpty() { window.location.reload(); }
    function checkZone() {
      var msg = $('#zoneMsg'); msg.className = 'zone-msg';
      if (state.method !== 'local') return;
      var tier = zipTier($('#f_zip').value);
      if (tier === null) return;
      msg.classList.add('show', tier === 'out' ? 'bad' : 'ok');
      msg.textContent = tier === 'free' ? 'Great — that ZIP is inside our free local delivery area.' :
        tier === 'ext' ? 'We deliver there for ' + money(STORE.localDelivery.extended.fee) + ' (outside our free area). It\u2019s included in your total.' :
        'That ZIP is outside our local delivery area (up to ' + STORE.localDelivery.extended.radiusMiles + ' miles). Choose "Ship to my address" or free pickup instead.';
    }
    app.addEventListener('change', function (e) { if (e.target.name === 'method') { state.method = e.target.value; render(); } });
    app.addEventListener('input', function (e) { if (e.target.id === 'f_zip') { var before = currentZip; currentZip = e.target.value; if (zipTier(before) !== zipTier(currentZip)) render(); else checkZone(); } });

    function setErr(id, text) { var f = $('[data-f="' + id + '"]'); if (!f) return; f.classList.toggle('invalid', !!text); $('.err', f).textContent = text || ''; }
    function val(id) { var el = $('#f_' + id); return el ? el.value.replace(/[\u200B-\u200D\uFEFF]/g, '').trim() : ''; }
    function validate() {
      var ok = true, firstBad = null;
      function need(id, cond, msg) { setErr(id, cond ? '' : msg); if (!cond) { ok = false; firstBad = firstBad || id; } }
      need('name', val('name').length > 1, 'Please enter your name.');
      need('phone', val('phone').replace(/\D/g, '').length >= 10, 'Enter a 10-digit phone number.');
      need('email', /^\S+@\S+\.\S+$/.test(val('email')), 'Enter a valid email address.');
      if (isDeposit(state.method, lines)) need('depositOk', $('#f_depositOk').checked, 'Please confirm you understand the deposit is non-refundable.');
      if (state.method !== 'pickup') {
        need('address1', val('address1').length > 3, 'Enter your street address.');
        need('city', val('city').length > 1, 'Enter your city.');
        need('state', /^[A-Za-z]{2}$/.test(val('state')), 'Use the 2-letter state.');
        if (state.method === 'ship' && /^[A-Za-z]{2}$/.test(val('state')) && S.shipping.states.indexOf(val('state').toUpperCase()) === -1) need('state', false, 'We ship to the continental U.S. only.');
        if (state.method === 'ship' && /^(006|007|008|009|967|968|969|995|996|997|998|999)/.test(val('zip'))) need('zip', false, 'We ship to the continental U.S. only.');
        var zipOk = /^\d{5}(-\d{4})?$/.test(val('zip'));
        need('zip', zipOk, 'Enter a 5-digit ZIP.');
        if (zipOk && state.method === 'local') need('zip', zipInLocalZone(val('zip')), 'Outside our delivery area.');
      }
      if (firstBad) { var el = $('#f_' + firstBad); if (el) el.focus(); }
      return ok;
    }
    function onPlace() {
      var boxes = [$('#coError'), $('#coError2')];
      var errBox = { classList: { add: function (c) { boxes.forEach(function (b) { b.classList.add(c); }); }, remove: function (c) { boxes.forEach(function (b) { b.classList.remove(c); }); } } };
      Object.defineProperty(errBox, 'textContent', { set: function (v) { boxes.forEach(function (b) { b.textContent = v; }); } });
      errBox.classList.remove('show');
      if (!validate()) { errBox.textContent = 'Please fix the highlighted fields above, then try again.'; errBox.classList.add('show'); return; }
      var btn = { set disabled(v) { $('#placeBtn').disabled = v; $('#placeBtn2').disabled = v; }, get textContent() { return $('#placeBtn').textContent; }, set textContent(v) { $('#placeBtn').textContent = v; $('#placeBtn2').textContent = v; } };
      var t = totals();
      var order = {
        method: state.method, payFull: payFullFlag && depositEligible(state.method, lines), items: lines.map(function (l) { return { id: l.p.id, qty: l.qty }; }),
        customer: { name: val('name'), email: val('email'), phone: val('phone'), notes: $('#f_notes').value.trim() },
        pickupLocation: state.method === 'pickup' ? pickupLoc().id : null,
        address: state.method === 'pickup' ? null : { line1: val('address1'), line2: val('address2'), city: val('city'), state: val('state').toUpperCase(), zip: val('zip') }
      };
      if (S.checkoutEndpoint) {
        var snapS = {
          method: state.method, total: t.total, sub: t.sub, fee: t.fee, due: t.due, balance: t.balance, customer: order.customer, address: order.address, pickupName: state.method === 'pickup' ? pickupLoc().name + ' (' + pickupLoc().address + ')' : '',
          items: lines.map(function (l) { return { name: l.p.name, qty: l.qty, price: l.p.price, image: l.p.image }; }), at: Date.now()
        };
        try { sessionStorage.setItem(ORDER_KEY, JSON.stringify(snapS)); } catch (e) { /* ignore */ }
        var label0 = btn.textContent;
        btn.disabled = true; btn.textContent = 'Redirecting to secure payment…';
        fetch(S.checkoutEndpoint, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(order) })
          .then(function (r) { return r.json().then(function (j) { if (!r.ok) throw new Error(j.error || 'Could not start checkout.'); return j; }); })
          .then(function (j) { window.location.href = j.url; })
          .catch(function (err) { btn.disabled = false; btn.textContent = label0; errBox.textContent = err.message + ' Please try again or call ' + S.business.phone + '.'; errBox.classList.add('show'); });
      } else if (S.orderRequestEndpoint) {
        // Interim live mode: email the order to the shop (same service as the contact form); payment is taken by phone.
        var snap0 = {
          method: state.method, total: t.total, sub: t.sub, fee: t.fee, due: t.due, balance: t.balance, customer: order.customer, address: order.address, pickupName: state.method === 'pickup' ? pickupLoc().name + ' (' + pickupLoc().address + ')' : '',
          items: lines.map(function (l) { return { name: l.p.name, qty: l.qty, price: l.p.price, image: l.p.image }; }), at: Date.now()
        };
        try { sessionStorage.setItem(ORDER_KEY, JSON.stringify(snap0)); } catch (e) { /* ignore */ }
        var addr = order.address ? [order.address.line1, order.address.line2, order.address.city + ', ' + order.address.state + ' ' + order.address.zip].filter(Boolean).join(', ') : 'N/A (pickup)';
        var methodName = state.method === 'pickup' ? 'FREE PICKUP' : state.method === 'local' ? 'LOCAL DELIVERY' : 'SHIP TO ADDRESS';
        var fields = {
          _subject: 'NEW ORDER (' + methodName + ') - NYC ATV Warehouse', _template: 'table', _captcha: 'false', _honey: '',
          _next: window.location.origin + window.location.pathname.replace(/checkout\.html$/, '') + 'order-complete.html?request=1',
          'How to get it': methodName + (state.method === 'pickup' ? ' - ' + pickupLoc().name + ' (' + pickupLoc().address + ')' : ''),
          'Items': lines.map(function (l) { return l.qty + ' x ' + l.p.name + ' @ ' + money(l.p.price); }).join('  |  '),
          'Deposit to collect': t.balance ? money(t.due) : 'Full payment: ' + money(t.due), 'Balance due at pickup/delivery': t.balance ? money(t.balance) : '$0',
          'Subtotal': money(t.sub), 'Delivery / shipping (estimate)': t.fee ? money(t.fee) : 'Free', 'Estimated total (before sales tax)': money(t.total),
          'name': order.customer.name, 'email': order.customer.email, 'phone': order.customer.phone,
          'Address': addr, 'Notes': order.customer.notes || ''
        };
        var f = document.createElement('form'); f.method = 'POST'; f.action = S.orderRequestEndpoint; f.style.display = 'none';
        Object.keys(fields).forEach(function (k) { var i = document.createElement('input'); i.type = 'hidden'; i.name = k; i.value = fields[k]; f.appendChild(i); });
        document.body.appendChild(f); btn.disabled = true; btn.textContent = 'Sending your order…';
        clearCart(); f.submit();
      } else {
        var snap = {
          method: state.method, total: t.total, sub: t.sub, fee: t.fee, due: t.due, balance: t.balance, customer: order.customer, address: order.address, pickupName: state.method === 'pickup' ? pickupLoc().name + ' (' + pickupLoc().address + ')' : '',
          items: lines.map(function (l) { return { name: l.p.name, qty: l.qty, price: l.p.price, image: l.p.image }; }), at: Date.now()
        };
        try { sessionStorage.setItem(ORDER_KEY, JSON.stringify(snap)); } catch (e) { /* ignore */ }
        clearCart(); window.location.href = BASE + 'order-complete.html?preview=1';
      }
    }
    $('#f_payFull').addEventListener('change', function () { payFullFlag = this.checked; render(); });
    $('#placeBtn').addEventListener('click', onPlace);
    $('#placeBtn2').addEventListener('click', onPlace);
    render();
  }

  /* ---------- order complete ---------- */
  function initComplete() {
    var host = $('#completeApp'); if (!host) return;
    var params = new URLSearchParams(window.location.search), S = STORE;
    var snap = null; try { snap = JSON.parse(sessionStorage.getItem(ORDER_KEY) || 'null'); } catch (e) { /* ignore */ }
    var isPreview = params.get('preview') === '1', isRequest = params.get('request') === '1';
    if (!isPreview) clearCart();
    var how = '';
    if (snap) {
      how = snap.method === 'pickup' ? 'Free pickup at ' + (snap.pickupName || S.business.address) + '. We’ll contact you when it’s ready.'
        : snap.method === 'local' ? 'Local delivery to ' + snap.address.line1 + ', ' + snap.address.city + ', ' + snap.address.state + ' ' + snap.address.zip + '. We’ll call to schedule a delivery time.'
          : 'Shipping to ' + snap.address.line1 + ', ' + snap.address.city + ', ' + snap.address.state + ' ' + snap.address.zip + '. We\u2019ll confirm the final shipping cost with you before charging.';
    }
    host.innerHTML = '<div class="container" style="max-width:760px"><div class="empty-state"><div class="success-icon">' + ICON.check + '</div>' +
      '<h1>' + (isPreview ? 'Order confirmation (preview)' : isRequest ? 'Thank you \u2014 we got your order!' : 'Thank you — order received!') + '</h1>' +
      '<p>' + (isPreview ? 'This is a preview of the page customers see after paying. No order was placed and no card was charged.' : isRequest ? 'We\u2019ll contact you within 1 business day to confirm your order and take payment. You have not been charged. Questions? Call ' + S.business.phone + '.' : 'We’ve emailed your receipt. We’ll contact you within 1 business day to arrange ' + (snap ? (snap.method === 'pickup' ? 'pickup' : snap.method === 'local' ? 'delivery' : 'shipping') : 'pickup, delivery or shipping') + '.') + '</p>' +
      (snap && snap.method === 'ship' && snap.items.some(function (i) { return !/helmet/i.test(i.name); }) ? '<div class="assembly-note" style="text-align:left;max-width:560px;margin:16px auto 0"><span class="ic">' + ICON.box + '</span><div><strong>' + esc(S.assembly.title) + '</strong><span>' + esc(S.assembly.text) + '</span></div></div>' : '') +
      (snap ? '<div class="co-card" style="text-align:left"><h2 style="font-size:1.4rem">Your order</h2>' +
        snap.items.map(function (i) { return '<div class="sum-line"><img src="' + esc(/^https?:/.test(i.image) ? i.image : BASE + i.image) + '" alt=""><div><strong>' + esc(i.name) + '</strong><small>Qty ' + i.qty + '</small></div><span>' + money(i.price * i.qty) + '</span></div>'; }).join('') +
        '<div class="sum-rows"><div><span>Subtotal</span><span>' + money(snap.sub) + '</span></div><div><span>' + (snap.method === 'pickup' ? 'Pickup' : snap.method === 'local' ? 'Local delivery' : 'Shipping') + '</span><span>' + (snap.fee ? money(snap.fee) : '<span class="free">Free</span>') + '</span></div><div class="t"><span>Order total</span><span>' + money(snap.total) + '</span></div>' +
        (snap.due != null ? '<div class="due"><span>' + (isRequest ? 'To be collected' : isPreview ? 'Paid today (preview)' : 'Paid today') + (snap.balance ? ' (deposit)' : '') + '</span><span>' + money(snap.due) + '</span></div>' : '') +
        (snap.balance ? '<div class="bal"><span>Balance due at ' + (snap.method === 'pickup' ? 'pickup' : 'delivery') + '</span><span>' + money(snap.balance) + '</span></div>' : '') + '</div>' +
        '<p style="margin-top:14px;color:var(--text-muted)"><strong style="color:var(--ink)">How you’ll get it:</strong> ' + esc(how) + '</p></div>' : '') +
      '<a class="btn btn-primary btn-lg" href="' + BASE + 'index.html">Back to the store</a></div></div>';
  }

  /* ---------- floating contact buttons (from the original site) ---------- */
  function initFab() {
    var fab = document.createElement('div'); fab.className = 'contact-fab';
    fab.innerHTML = '<a class="contact-fab-btn contact-fab-sms" href="sms:+16469431858" aria-label="Text us at 646-943-1858"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 4h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H8l-4 4V6a2 2 0 0 1 2-2z" fill="currentColor"/><circle cx="8" cy="11" r="1.4" fill="#fff"/><circle cx="12" cy="11" r="1.4" fill="#fff"/><circle cx="16" cy="11" r="1.4" fill="#fff"/></svg><span>Text Us</span></a>' +
      '<a class="contact-fab-btn contact-fab-messenger" href="https://m.me/nycatvs" target="_blank" rel="noopener" aria-label="Message us on Facebook Messenger"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 2C6.36 2 2 6.13 2 11.7c0 2.91 1.19 5.44 3.14 7.17.16.15.26.35.27.57l.05 1.78a.8.8 0 0 0 1.12.71l1.98-.87a.8.8 0 0 1 .53-.04c.91.25 1.88.38 2.91.38 5.64 0 10-4.13 10-9.7S17.64 2 12 2zm6 7.46-2.94 4.66a1.5 1.5 0 0 1-2.17.4l-2.34-1.75a.6.6 0 0 0-.72 0l-3.16 2.4c-.42.32-.97-.19-.69-.64l2.94-4.66a1.5 1.5 0 0 1 2.17-.4l2.34 1.75a.6.6 0 0 0 .72 0l3.16-2.4c.42-.32.97.19.69.64z"/></svg><span>Messenger</span></a>';
    document.body.appendChild(fab);
  }

  /* ---------- boot ---------- */
  buildDrawer();
  initFab();
  initHeader();
  initBuyButtons();
  renderCartUI();

  Promise.all([
    fetch(BASE + 'data/products.json').then(function (r) { return r.json(); }),
    fetch(BASE + 'data/store.json').then(function (r) { return r.json(); })
  ]).then(function (res) {
    CATALOG = res[0].products; STORE = res[1];
    CATALOG.forEach(function (p) { BY_ID[p.id] = p; });
    // drop cart lines for items that no longer exist / are no longer buyable
    cart = cart.filter(function (l) { return buyable(BY_ID[l.id]); }); saveCart();
    renderCartUI(); initPreviewRibbon(); initStoreText(); initFeatured(); initRelated(); initSort(); initCheckout(); initComplete();
  }).catch(function () {
    // Opened as a file:// page or offline: static pages still work, buying is unavailable.
    var n = document.createElement('div'); n.className = 'preview-ribbon';
    n.textContent = 'Store data could not be loaded. If you opened this file directly, view it through the preview server instead.';
    document.body.insertBefore(n, document.body.firstChild);
  });
})();

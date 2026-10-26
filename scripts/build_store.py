#!/usr/bin/env python3
"""
Builds the storefront pages from data files. Run from the repo root:

    python3 scripts/build_store.py

Inputs (edit these, then re-run):
  data/products.json   prices, names, categories, images   <- change prices HERE
  data/content.json    specs, photos and descriptions per product
  data/store.json      shipping / local delivery / pickup settings

Outputs: index.html, the six category pages, every page under scooters/ atvs/
dirtbikes/ gokarts/ utvs/ ebikes/, shipping-pickup.html, checkout.html,
order-complete.html, and the header/footer on contact.html and financing.html.
"""
import html as H
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)
SITE = "https://nycatvwarehouse.com"

PRODUCTS = json.load(open("data/products.json", encoding="utf-8"))["products"]
CONTENT = json.load(open("data/content.json", encoding="utf-8"))
STORE = json.load(open("data/store.json", encoding="utf-8"))
GTAG = open("scripts/snippets/gtag.html", encoding="utf-8").read()
LIVECHAT = ""  # live chat widget removed at owner request
TESTIMONIALS = open("scripts/snippets/testimonials.html", encoding="utf-8").read()
BY_ID = {p["id"]: p for p in PRODUCTS}

CATS = [("scooters", "Scooters"), ("atvs", "ATVs"), ("dirtbikes", "Dirt Bikes"),
        ("gokarts", "Go-Karts"), ("utvs", "UTVs"), ("ebikes", "E-Bikes")]
CAT_LABEL = dict(CATS)
CAT_COUNT = {c: sum(1 for p in PRODUCTS if p["category"] == c) for c, _ in CATS}

ICON = {
    "pin": '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s7-6.3 7-12a7 7 0 10-14 0c0 5.7 7 12 7 12z"/><circle cx="12" cy="10" r="2.5"/></svg>',
    "truck": '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7h11v9H3zM14 10h4l3 3v3h-7z"/><circle cx="7.5" cy="17.5" r="1.8"/><circle cx="17.5" cy="17.5" r="1.8"/></svg>',
    "box": '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7.5L12 3l9 4.5v9L12 21l-9-4.5z"/><path d="M3 7.5l9 4.5 9-4.5M12 12v9"/></svg>',
    "search": '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/></svg>',
    "cart": '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"><path d="M3 4h2.5l2.2 11h10.1l2-8H6.6"/><circle cx="9" cy="19.5" r="1.5"/><circle cx="17" cy="19.5" r="1.5"/></svg>',
    "check": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6L9 17l-5-5"/></svg>',
    "check20": '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>',
}


def money(n):
    if n is None:
        return None
    return "${:,.2f}".format(n).replace(".00", "") if round(n * 100) % 100 == 0 else "${:,.2f}".format(n)


def fee_text(n):
    return "Free" if not n else money(n)


def buyable(p):
    return p["inStock"] and isinstance(p.get("price"), (int, float)) and p["price"] > 0


# --------------------------------------------------------------------------- chrome
def topbar():
    b = STORE["business"]
    return f'''<div class="topbar"><div class="container topbar-inner">
  <div class="topbar-items">
    <span>{ICON["pin"]}Free pickup in Little Ferry, NJ</span>
    <span>{ICON["truck"]}Free local delivery &middot; NYC Metro</span>
    <span>{ICON["box"]}Shipped to your door</span>
  </div>
  <a class="topbar-phone" href="{b["phoneHref"]}">Call {b["phone"]}</a>
</div></div>'''


def header(base, active=None):
    b = STORE["business"]
    links = "".join(
        f'<a href="{base}{c}.html"{" class=\"active\"" if c == active else ""}>{label}</a>' for c, label in CATS)
    extra = (f'<span class="nav-spacer"></span>'
             f'<a href="{base}shipping-pickup.html"{" class=\"active\"" if active == "shipping" else ""}>Delivery &amp; Pickup</a>'
             f'<a href="{base}contact.html"{" class=\"active\"" if active == "contact" else ""}>Contact</a>')
    return f'''<!-- SITE-HEADER-START -->
{topbar()}
<header class="site-header">
  <div class="container header-inner">
    <button class="nav-toggle" id="navToggle" aria-label="Toggle menu"><span></span><span></span><span></span></button>
    <a href="{base}index.html" class="logo"><img class="logo-mark" src="{base}images/logo.png" alt="NYC ATV Warehouse Scooter Co."></a>
    <form class="search" role="search" autocomplete="off">
      {ICON["search"]}
      <input id="siteSearch" type="search" placeholder="Search scooters, ATVs, dirt bikes&hellip;" aria-label="Search the store">
      <div class="search-results" id="searchResults"></div>
    </form>
    <div class="header-actions">
      <div class="header-call"><small>Questions? Call us</small><a href="{b["phoneHref"]}">{b["phone"]}</a></div>
      <button class="cart-btn" type="button" aria-label="Open cart">{ICON["cart"]}<span class="cart-label">Cart</span><span class="cart-count">0</span></button>
    </div>
  </div>
  <nav class="cat-nav" aria-label="Shop categories"><div class="container cat-nav-inner">{links}{extra}</div></nav>
</header>
<!-- SITE-HEADER-END -->'''


def footer(base):
    b = STORE["business"]
    shop = "".join(f'<li><a href="{base}{c}.html">{l}</a></li>' for c, l in CATS)
    return f'''<!-- SITE-FOOTER-START -->
<footer class="site-footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <a href="{base}index.html" class="logo"><img class="logo-mark" src="{base}images/logo.png" alt="NYC ATV Warehouse Scooter Co."></a>
        <p>Scooters, ATVs, dirt bikes, go-karts, UTVs and e-bikes &mdash; shipped to your door, delivered locally for free, or ready for free pickup in Little Ferry, NJ.</p>
        <div class="social-row">
          <a href="https://www.facebook.com/NYCATVWAREHOUSE" target="_blank" rel="noopener" aria-label="Facebook"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M22 12a10 10 0 10-11.6 9.9v-7H7.9V12h2.5V9.8c0-2.5 1.5-3.9 3.8-3.9 1.1 0 2.2.2 2.2.2v2.4h-1.2c-1.2 0-1.6.8-1.6 1.6V12h2.8l-.4 2.9h-2.4v7A10 10 0 0022 12z"/></svg></a>
        </div>
      </div>
      <div class="footer-col"><h4>Shop</h4><ul>{shop}</ul></div>
      <div class="footer-col"><h4>Help</h4><ul>
        <li><a href="{base}shipping-pickup.html">Shipping, delivery &amp; pickup</a></li>
        <li><a href="{base}financing.html">Financing</a></li>
        <li><a href="{base}index.html#service">Service &amp; parts</a></li>
        <li><a href="{base}index.html#reviews">Reviews</a></li>
        <li><a href="{base}contact.html">Contact</a></li>
      </ul></div>
      <div class="footer-col"><h4>Visit us</h4><ul>
        <li>207 Gates Rd<br>Little Ferry, NJ 07643</li>
        <li><a href="{b["phoneHref"]}">{b["phone"]}</a></li>
        <li>Mon&ndash;Fri: 10am&ndash;5pm<br>Sat&ndash;Sun: Closed</li>
      </ul></div>
    </div>
    <div class="footer-bottom">
      <span>&copy; <span id="year"></span> NYC ATV Warehouse. All rights reserved.</span>
      <span>Little Ferry, NJ &middot; Serving the NYC Metro Area</span>
    </div>
  </div>
</footer>
<!-- SITE-FOOTER-END -->'''


def head(title, desc, path, og_image=None, jsonld=None, noindex=False, base="", og_type="website"):
    url = f"{SITE}/{path}" if path else f"{SITE}/"
    img = f"{SITE}/{og_image}" if og_image else f"{SITE}/images/logo.png"
    t, d = H.escape(title, quote=True), H.escape(desc, quote=True)
    robots = '<meta name="robots" content="noindex, nofollow">\n' if noindex else ""
    ld = f'<script type="application/ld+json">{json.dumps(jsonld, separators=(",", ":"), ensure_ascii=False)}</script>\n' if jsonld else ""
    canon = "" if noindex else f'<link rel="canonical" href="{url}">\n'
    og = "" if noindex else f'''<meta property="og:type" content="{og_type}">
<meta property="og:site_name" content="NYC ATV Warehouse">
<meta property="og:title" content="{t}">
<meta property="og:description" content="{d}">
<meta property="og:url" content="{url}">
<meta property="og:image" content="{img}">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="{t}">
<meta name="twitter:description" content="{d}">
<meta name="twitter:image" content="{img}">
'''
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
{GTAG}<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{t}</title>
<meta name="description" content="{d}">
{robots}<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="{base}css/style.css">
{canon}{og}{ld}</head>'''


def page(head_html, body_inner, base, body_class=""):
    cls = f' class="{body_class}"' if body_class else ""
    return f'''{head_html}
<body data-base="{base}"{cls}>

{body_inner}

<script src="{base}js/script.js"></script>
{LIVECHAT}
</body>
</html>
'''


def write(path, text):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


# --------------------------------------------------------------------------- cards
def card(p, base=""):
    c = CONTENT["products"][p["id"]]
    price = (f'<p class="bike-price">{money(p["price"])}</p>' if buyable(p)
             else '<p class="bike-price call">Call for pricing</p>')
    actions = (f'<button class="btn btn-primary" type="button" data-add="{p["id"]}">Add to cart</button>' if buyable(p)
               else f'<a class="btn btn-dark" href="{STORE["business"]["phoneHref"]}">Call to order</a>')
    bullets = "".join(f"<li>{b}</li>" for b in c["bullets"][:3])
    return f'''      <div class="bike-card" data-id="{p["id"]}">
        <a href="{base}{p["url"]}"><img loading="lazy" decoding="async" src="{base}{p["image"]}" alt="{H.escape(p["name"], quote=True)} {CAT_LABEL[p["category"]].rstrip("s").lower()}"></a>
        <div class="bike-card-body">
          <div class="bike-card-cat">{CAT_LABEL[p["category"]]}</div>
          <h3><a href="{base}{p["url"]}">{p["name"]}</a></h3>
          {price}
          <ul>{bullets}</ul>
          <div class="card-actions">{actions}</div>
        </div>
      </div>'''


def side_cats(base, active=None):
    items = "".join(
        f'<a href="{base}{c}.html"{" class=\"active\"" if c == active else ""}>{l}<span>{CAT_COUNT[c]}</span></a>' for c, l in CATS)
    return f'<div class="side-cats"><h3>Shop by category</h3>{items}</div>'


def side_box(base):
    s = STORE
    return f'''<div class="side-box"><h4>Ways to get it</h4><ul>
  <li>{ICON["check"]}<span><strong>Free pickup</strong> at our Little Ferry, NJ warehouse</span></li>
  <li>{ICON["check"]}<span><strong>Free local delivery</strong> across {s["localDelivery"]["zoneLabel"]}</span></li>
  <li>{ICON["check"]}<span><strong>Shipped</strong> to your address</span></li>
</ul><a class="link" href="{base}shipping-pickup.html">Delivery details &rarr;</a></div>'''


# --------------------------------------------------------------------------- pages
def build_category(cat):
    info = CONTENT["categories"][cat]
    label = CAT_LABEL[cat]
    intro = re.sub(r"\s*Call or stop by[^.]*\.", "", info["intro"]).strip()
    intro += " Order online and have it shipped, delivered locally for free, or pick it up free."
    prods = [p for p in PRODUCTS if p["category"] == cat]
    # keep the original on-page order from the old category page
    order = {pid: i for i, pid in enumerate(CONTENT["order"][cat])}
    prods.sort(key=lambda p: order.get(p["id"], 999))
    cards = "\n".join(card(p) for p in prods)
    body = f'''{header("", cat)}

<main>
<div class="container crumbs"><a href="index.html">Home</a><span>/</span>{label}</div>
<section class="page-head" style="padding-bottom:0"><div class="container">
  <h1 class="section-title">{info["title"]}</h1>
  <p>{intro}</p>
</div></section>

<section style="padding-top:26px">
  <div class="container shop-layout">
    <aside>{side_cats("", cat)}{side_box("")}</aside>
    <div>
      <div class="shop-toolbar">
        <span class="shop-count">{len(prods)} products</span>
        <label class="shop-sort">Sort by
          <select id="sortSel"><option value="featured">Featured</option><option value="low">Price: low to high</option><option value="high">Price: high to low</option><option value="az">Name: A&ndash;Z</option></select>
        </label>
      </div>
      <div class="bike-grid" id="productGrid">
{cards}
      </div>
    </div>
  </div>
</section>
</main>

{footer("")}'''
    ld = {"@context": "https://schema.org", "@type": "ItemList", "name": label,
          "itemListElement": [{"@type": "ListItem", "position": i + 1, "url": f"{SITE}/{p['url'][:-5]}"} for i, p in enumerate(prods)]}
    write(f"{cat}.html", page(head(info["title_tag"], info["meta"], cat, jsonld=ld), body, ""))


def product_jsonld(p, c):
    imgs = [f"{SITE}/{t}" for t in c["thumbs"]]
    d = {"@context": "https://schema.org", "@type": "Product", "name": p["name"], "description": c["description"],
         "category": CAT_LABEL[p["category"]], "url": f"{SITE}/{p['url'][:-5]}", "image": imgs,
         "brand": {"@type": "Brand", "name": "NYC ATV Warehouse"}}
    if buyable(p):
        d["offers"] = {"@type": "Offer", "url": f"{SITE}/{p['url'][:-5]}", "priceCurrency": "USD",
                       "price": f"{p['price']:.2f}".rstrip("0").rstrip("."),
                       "availability": "https://schema.org/InStock", "itemCondition": "https://schema.org/NewCondition",
                       "seller": {"@type": "Organization", "name": "NYC ATV Warehouse"}}
    return d


def assembly_note(extra=""):
    a = STORE["assembly"]
    return f'<div class="assembly-note {extra}"><span class="ic">{ICON["box"]}</span><div><strong>{a["title"]}</strong><span>{a["text"]}</span></div></div>'


def fulfil_opts(p):
    s = STORE
    dep = money(s["deposit"]["amount"])
    rate = s["shipping"]["perUnitByCategory"].get(p["category"], 0)
    return f'''<div class="fulfil-opts">
  <div class="fulfil-opt"><span class="ic">{ICON["pin"]}</span><div><strong>Free pickup &mdash; <span class="free">Free</span></strong><span class="d">Ready at our Little Ferry, NJ warehouse. Mon&ndash;Fri 10am&ndash;5pm. {dep} deposit online, balance at pickup.</span></div></div>
  <div class="fulfil-opt"><span class="ic">{ICON["truck"]}</span><div><strong>Free local delivery{"" if not s["localDelivery"]["fee"] else " &mdash; " + fee_text(s["localDelivery"]["fee"])}</strong><span class="d">Free across {s["localDelivery"]["zoneLabel"]}. {money(s["localDelivery"]["extended"]["fee"])} for Long Island and up to {s["localDelivery"]["extended"]["radiusMiles"]} miles. {dep} deposit online, balance on delivery.</span></div></div>
  <div class="fulfil-opt"><span class="ic">{ICON["box"]}</span><div><strong>Shipped to your address &mdash; <span data-ship-rate="{p["category"]}">{money(rate)}</span> per unit</strong><span class="d">Pay in full online. Shipping is calculated at checkout. Ships about 90% assembled in a crate &mdash; handlebars, wheels and a few other parts may need to be attached before it is ready to ride. Assembly instructions are included.</span></div></div>
</div>'''


def build_product(p):
    c = CONTENT["products"][p["id"]]
    cat, label = p["category"], CAT_LABEL[p["category"]]
    base = "../"
    desc = c["description"].replace("Full specs, pricing, and availability.",
                                    "Buy online — shipping, local delivery or free pickup.")
    thumbs = "".join(
        f'<img{"" if i == 0 else " loading=\"lazy\" decoding=\"async\""} src="{base}{t}" class="thumb{" active" if i == 0 else ""}" alt="{H.escape(p["name"], quote=True)} photo {i + 1}">'
        for i, t in enumerate(c["thumbs"]))
    thumbs_html = f'<div class="gallery-thumbs">{thumbs}</div>' if len(c["thumbs"]) > 1 else ""
    specs = "".join(f"<li><strong>{k}</strong><span>{v}</span></li>" for k, v in c["specs"])
    if buyable(p):
        price = f'<div class="pdp-price">{money(p["price"])}</div>'
        stock = '<div class="pdp-stock">In stock</div>'
        buy = f'''<div class="buy-box">
  <div class="buy-row">
    <div class="qty"><button type="button" id="pdpDec" aria-label="Decrease quantity">&minus;</button><input id="pdpQty" type="number" min="1" max="{STORE["maxQtyPerItem"]}" value="1" aria-label="Quantity"><button type="button" id="pdpInc" aria-label="Increase quantity">+</button></div>
    <button class="btn btn-primary btn-lg" type="button" data-add="{p["id"]}" data-use-qty>Add to cart</button>
  </div>
  <div class="buy-row" style="margin-top:12px"><button class="btn btn-buy btn-lg btn-block" type="button" data-buy="{p["id"]}" data-use-qty>Buy it now</button></div>
  <p class="buy-note">Choose shipping, local delivery or free pickup at checkout.</p>
  {fulfil_opts(p)}
</div>'''
        mobile = f'''<div class="mobile-buybar"><div><div class="mb-price">{money(p["price"])}</div><div class="mb-name">{H.escape(p["name"])}</div></div><button class="btn btn-primary" type="button" data-add="{p["id"]}">Add to cart</button></div>'''
    else:
        price = '<div class="pdp-price call">Call for pricing</div>'
        stock = ""
        buy = f'''<div class="buy-box"><a class="btn btn-primary btn-lg btn-block" href="{STORE["business"]["phoneHref"]}">Call {STORE["business"]["phone"]} to order</a>
  <p class="buy-note">Online pricing for this model is coming soon.</p></div>'''
        mobile = ""
    body = f'''{header(base, cat)}

<main>
<div class="container crumbs"><a href="{base}index.html">Home</a><span>/</span><a href="{base}{cat}.html">{label}</a><span>/</span>{p["name"]}</div>

<section class="pdp" id="pdp" data-id="{p["id"]}">
  <div class="container pdp-grid">
    <div class="pdp-gallery">
      <div class="pdp-main"><img id="mainPhoto" src="{base}{c["main"]}" alt="{H.escape(p["name"], quote=True)}"></div>
      {thumbs_html}
    </div>
    <div class="pdp-info">
      <p class="pdp-cat">{label}</p>
      <h1>{p["name"]}</h1>
      {price}
      {stock}
      {buy}
      <div class="pdp-specs">
        <h2>Specifications</h2>
        <ul class="spec-list">{specs}</ul>
      </div>
      <div class="pdp-help"><span>Questions about this {label.rstrip("s").lower()}? Talk to a real rider.</span><a href="{STORE["business"]["phoneHref"]}">Call {STORE["business"]["phone"]}</a></div>
    </div>
  </div>
</section>

<section class="related section-alt" id="related" data-id="{p["id"]}" data-cat="{cat}">
  <div class="container">
    <div class="row-head"><h2>More {label}</h2><a class="more" href="{base}{cat}.html">View all {label} &rarr;</a></div>
    <div class="bike-grid"></div>
  </div>
</section>
</main>

{mobile}
{footer(base)}'''
    ttl = f'{p["name"]} | {label} | NYC ATV Warehouse'
    write(p["url"], page(head(ttl, desc, p["url"][:-5], c["main"], product_jsonld(p, c), base=base, og_type="product"),
                         body, base, "has-buybar" if mobile else ""))


def build_home():
    s = STORE
    feat = BY_ID["scooters-tank-pro-x200-elite"]
    fc = CONTENT["products"][feat["id"]]
    picks = ["scooters-tank-pro-x200-elite", "atvs-cyber-roamer-300-efi", "dirtbikes-thunder-250cc", "scooters-intrepid-200",
             "ebikes-ouxi-gt-2000", "atvs-pentora-sport-250cc", "gokarts-t-rex-125cc", "utvs-cross-fire-200-efi"]
    picks = [i for i in picks if i in BY_ID]
    pick_cards = "\n".join(card(BY_ID[i]) for i in picks)
    tiles = [("scooters", "images/scooter.png"), ("atvs", "images/atv.jpg"), ("dirtbikes", "images/dirtbike.jpg"),
             ("gokarts", "images/go-kart.jpg"), ("utvs", "images/utv.jfif"), ("ebikes", "images/gt2000.jfif")]
    tile_html = "".join(
        f'''<a class="category-card" href="{c}.html"><img{"" if i == 0 else " loading=\"lazy\" decoding=\"async\""} src="{im}" alt="{CAT_LABEL[c]} for sale at NYC ATV Warehouse"><div class="category-card-label"><h3>{CAT_LABEL[c]}</h3><span>{CAT_COUNT[c]} models</span></div></a>'''
        for i, (c, im) in enumerate(tiles))
    ld = {"@context": "https://schema.org", "@type": "MotorcycleDealer", "@id": f"{SITE}/#business", "name": "NYC ATV Warehouse",
          "url": f"{SITE}/", "image": f"{SITE}/images/logo.png", "logo": f"{SITE}/images/logo.png",
          "description": "Scooters, ATVs, dirt bikes, go-karts, UTVs and e-bikes. Shipped to your door, delivered locally for free, or free pickup in Little Ferry, NJ.",
          "telephone": "+1-646-943-1858",
          "address": {"@type": "PostalAddress", "streetAddress": "207 Gates Rd", "addressLocality": "Little Ferry", "addressRegion": "NJ", "postalCode": "07643", "addressCountry": "US"},
          "openingHoursSpecification": [{"@type": "OpeningHoursSpecification", "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"], "opens": "10:00", "closes": "17:00"}],
          "areaServed": "New York Metro Area", "sameAs": ["https://www.facebook.com/NYCATVWAREHOUSE"]}
    fulfil = f'''<section class="fulfil-strip"><div class="container"><div class="fulfil-grid">
  <div class="fulfil-card"><span class="ic">{ICON["pin"]}</span><div><h3>Free pickup</h3><p>Order online, then pick it up at our Little Ferry, NJ warehouse. No fee.</p><span class="tag">Free</span></div></div>
  <div class="fulfil-card"><span class="ic">{ICON["truck"]}</span><div><h3>Free local delivery</h3><p>Free across {s["localDelivery"]["zoneLabel"]}. Long Island and up to {s["localDelivery"]["extended"]["radiusMiles"]} miles: {money(s["localDelivery"]["extended"]["fee"])}.</p><span class="tag">Free / {money(s["localDelivery"]["extended"]["fee"])}</span></div></div>
  <div class="fulfil-card"><span class="ic">{ICON["box"]}</span><div><h3>Shipped to you</h3><p>Every model can be ordered online and shipped to your address. Ships about 90% assembled in a crate; handlebars, wheels and a few other parts may need to be attached.</p><span class="tag" style="background:var(--accent-soft);color:var(--accent)">Rates at checkout</span></div></div>
</div></div></section>'''
    body = f'''{header("")}

<main>
<section class="store-top" style="padding-bottom:0"><div class="container store-top-grid">
  {side_cats("")}
  <div class="hero">
    <div class="hero-content">
      <p class="eyebrow">NYC ATV Warehouse</p>
      <h1>Find your ride. <em>Order online.</em></h1>
      <p>Scooters, ATVs, dirt bikes, go-karts, UTVs and e-bikes &mdash; shipped to your door, delivered locally for free, or ready for free pickup in Little Ferry, NJ.</p>
      <div class="hero-actions"><a class="btn btn-buy btn-lg" href="#shop">Shop now</a><a class="btn btn-outline btn-lg" href="shipping-pickup.html">Delivery &amp; pickup</a></div>
    </div>
    <a class="hero-card" href="{feat["url"]}" aria-label="Featured: {H.escape(feat["name"])}">
      <span class="hc-tag">Featured</span>
      <img src="{fc["main"]}" alt="{H.escape(feat["name"])}">
      <span class="hc-name">{feat["name"]}</span>
      <span class="hc-price">{money(feat["price"]) if buyable(feat) else "Call for pricing"}</span>
    </a>
  </div>
</div></section>

{fulfil}

<section id="shop" style="padding-top:44px">
  <div class="container">
    <div class="row-head"><h2>Shop by category</h2></div>
    <div class="category-grid">{tile_html}</div>
  </div>
</section>

<section class="section-alt" id="featured">
  <div class="container">
    <div class="row-head"><h2>Popular right now</h2><a class="more" href="scooters.html">Browse everything &rarr;</a></div>
    <div class="bike-grid">
{pick_cards}
    </div>
  </div>
</section>

<section id="why-us">
  <div class="container">
    <div class="section-head center">
      <p class="eyebrow">Why shop with us</p>
      <h2 class="section-title">The warehouse advantage</h2>
      <p>A full warehouse stocked deep across six categories, backed by a team that actually rides &mdash; now open to order online, wherever you are.</p>
    </div>
    <div class="feature-grid">
      <div class="feature-card"><svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 12l2-6h14l2 6M5 12h14v6H5z"/><circle cx="8" cy="18" r="1.6"/><circle cx="16" cy="18" r="1.6"/></svg><h3>Massive selection</h3><p>Six categories and 100+ models &mdash; chances are we already have what you&rsquo;re looking for.</p></div>
      <div class="feature-card"><svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 2l3 6 6 1-4.5 4.5L17.5 20 12 17l-5.5 3 1-6.5L3 9l6-1 3-6z"/></svg><h3>Trusted locally</h3><p>Serving riders across NJ and the NYC metro with straightforward pricing and honest recommendations.</p></div>
      <div class="feature-card"><svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="2"/><path d="M3 10h18M7 15h4"/></svg><h3>Up to 30% off</h3><p>Select units discounted by up to 30% so you get the lowest price possible.</p></div>
      <div class="feature-card"><svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M4.9 19.1L7 17M17 7l2.1-2.1"/></svg><h3>Full-service shop</h3><p>In-house service and a stocked parts counter, so keeping your ride running is never a hassle.</p></div>
    </div>
  </div>
</section>

<section class="section-alt" id="financing">
  <div class="container split">
    <div class="split-media"><img loading="lazy" decoding="async" src="images/financing.jpg" alt="Discounted units at NYC ATV Warehouse"></div>
    <div class="split-text">
      <p class="eyebrow">Lowest price</p>
      <h2 class="section-title">Get riding, your way</h2>
      <p>Financing is currently unavailable, but we&rsquo;ve discounted select units by up to 30% to give you the lowest price possible.</p>
      <ul>
        <li>{ICON["check20"]} Select units discounted by up to 30%</li>
        <li>{ICON["check20"]} Questions? Call or stop by the warehouse</li>
      </ul>
      <a href="scooters.html" class="btn btn-primary">Shop deals</a><a href="financing.html" class="btn btn-outline">Financing info</a>
    </div>
  </div>
</section>

<section id="service">
  <div class="container split reverse">
    <div class="split-media"><img loading="lazy" decoding="async" src="images/service.jpg" alt="Service and parts counter at NYC ATV Warehouse"></div>
    <div class="split-text">
      <p class="eyebrow">Service &amp; Parts</p>
      <h2 class="section-title">Keep it running</h2>
      <p>Our service bay handles everything from routine maintenance to full rebuilds, and our parts counter is stocked for scooters, ATVs, dirt bikes, go-karts, UTVs and e-bikes alike.</p>
      <ul>
        <li>{ICON["check20"]} Routine maintenance &amp; tune-ups</li>
        <li>{ICON["check20"]} OEM &amp; aftermarket parts counter</li>
        <li>{ICON["check20"]} Repairs across every category we sell</li>
      </ul>
      <a href="contact.html" class="btn btn-primary">Book service</a>
    </div>
  </div>
</section>

{TESTIMONIALS}

<div class="cta-banner">
  <div class="container">
    <h2>Not sure which one is right?</h2>
    <p>Call or stop by the warehouse in Little Ferry, NJ &mdash; we&rsquo;ll help you find the right ride.</p>
    <a href="tel:16469431858" class="btn btn-primary btn-lg">Call 646-943-1858</a>
  </div>
</div>
</main>

{footer("")}'''
    write("index.html", page(head("NYC ATV Warehouse | Scooters, ATVs, UTVs, Dirt Bikes & More — Shop Online",
                                  "Shop scooters, ATVs, dirt bikes, go-karts, UTVs and e-bikes online. Shipped to your door, free local delivery, or free pickup in Little Ferry, NJ. Call 646-943-1858.",
                                  "", jsonld=ld), body, ""))


def build_shipping():
    s = STORE
    rows = "".join(
        f'<li><strong>{CAT_LABEL[c]}</strong>: <span data-ship-rate="{c}">{money(r)}</span> per unit</li>'
        for c, r in s["shipping"]["perUnitByCategory"].items())
    body = f'''{header("", "shipping")}

<main>
<div class="container crumbs"><a href="index.html">Home</a><span>/</span>Shipping, delivery &amp; pickup</div>
<section style="padding-top:24px"><div class="container">
  <div class="section-head"><p class="eyebrow">How it works</p><h1 class="section-title">Shipping, delivery &amp; pickup</h1>
  <p>Order online, then choose the way you want to get it at checkout. Every in-stock model can be shipped, delivered locally for free, or picked up.</p></div>

  <div class="info-cards">
    <div class="info-card"><span class="ic">{ICON["pin"]}</span><h3>Free pickup</h3><p>Pick up your order at our warehouse: {s["business"]["address"]}. {s["business"]["hours"].replace("-", "&ndash;")}. We&rsquo;ll contact you when it&rsquo;s ready. Pay a {money(s["deposit"]["amount"])} deposit online; the balance is due at pickup.</p><div class="price free">Free</div></div>
    <div class="info-card"><span class="ic">{ICON["truck"]}</span><h3>Free local delivery</h3><p>Delivery is free across {s["localDelivery"]["zoneLabel"]}. Anywhere on Long Island (Nassau and Suffolk) and up to {s["localDelivery"]["extended"]["radiusMiles"]} miles from us is {money(s["localDelivery"]["extended"]["fee"])}. Enter your ZIP at checkout to see your price. Pay a {money(s["deposit"]["amount"])} deposit online; the balance is due on delivery.</p><div class="price free">{fee_text(s["localDelivery"]["fee"])}</div></div>
    <div class="info-card"><span class="ic">{ICON["box"]}</span><h3>Shipped to you</h3><p>Ordering from out of town? We ship to your address. The rate depends on the type of vehicle and is shown before you pay. Shipped orders are paid in full online.</p><div class="price">Rate at checkout</div></div>
  </div>

  <div class="prose">
    <h2>Shipping rates</h2>
    <ul>{rows}</ul>
    <h2>What to expect when your shipped unit arrives</h2>
    <p>{STORE["assembly"]["text"]}</p>
    <h2>How payment works</h2>
    <ul>
      <li><strong>Free pickup and free local delivery:</strong> pay a {money(s["deposit"]["amount"])} deposit online. You pay the remaining balance when you pick up or when we deliver.</li>
      <li><strong>Shipping:</strong> pay the full amount online, including shipping.</li>
    </ul>
    <h2>After you order</h2>
    <p>We&rsquo;ll contact you within 1 business day to confirm your order and arrange pickup, delivery or shipping.</p>
    <h2>Before you buy</h2>
    <p>Please check your state and local rules for registration, titling and where you may ride each type of vehicle. Not sure? <a href="contact.html">Ask us</a> or call <a href="{s["business"]["phoneHref"]}">{s["business"]["phone"]}</a>.</p>
    <a class="btn btn-primary btn-lg" href="index.html#shop" style="margin-top:14px">Start shopping</a>
  </div>
</div></section>
</main>

{footer("")}'''
    write("shipping-pickup.html", page(head("Shipping, Local Delivery & Free Pickup | NYC ATV Warehouse",
                                            "Order online from NYC ATV Warehouse: shipped to your door, free local delivery in NJ and NYC, or free pickup in Little Ferry, NJ.",
                                            "shipping-pickup"), body, ""))


def build_checkout():
    body = f'''{header("")}
<main id="checkoutApp" class="checkout"><div class="container"><p style="padding:60px 0;text-align:center;color:var(--text-muted)">Loading your cart&hellip;</p></div></main>
{footer("")}'''
    write("checkout.html", page(head("Checkout | NYC ATV Warehouse", "Secure checkout", "checkout", noindex=True), body, ""))
    body = f'''{header("")}
<main id="completeApp" class="checkout"><div class="container"><p style="padding:60px 0;text-align:center;color:var(--text-muted)">Loading&hellip;</p></div></main>
{footer("")}'''
    write("order-complete.html", page(head("Order complete | NYC ATV Warehouse", "Order complete", "order-complete", noindex=True), body, ""))


def swap_chrome(path):
    """Replace the header/footer on pages whose body we keep (contact, financing)."""
    s = open(path, encoding="utf-8").read()
    base = ""
    hdr = header(base, "contact" if path == "contact.html" else None)
    ftr = footer(base)
    if "<!-- SITE-HEADER-START -->" in s:
        s = re.sub(r"<!-- SITE-HEADER-START -->.*?<!-- SITE-HEADER-END -->", lambda m: hdr, s, flags=re.S)
        s = re.sub(r"<!-- SITE-FOOTER-START -->.*?<!-- SITE-FOOTER-END -->", lambda m: ftr, s, flags=re.S)
    else:
        s = re.sub(r"<!-- ===== Header ===== -->.*?<div class=\"hazard-strip\"></div>", lambda m: hdr, s, flags=re.S)
        s = re.sub(r"<!-- ===== Footer ===== -->\s*<footer.*?</footer>", lambda m: ftr, s, flags=re.S)
    s = re.sub(r"<body[^>]*>", '<body data-base="">', s, count=1)
    s = s.replace("family=Inter:wght@400;500;600;700&", "family=Inter:wght@400;500;600;700;800&")
    write(path, s)


def build_sitemap():
    s = open("sitemap.xml", encoding="utf-8").read()
    for extra in ("shipping-pickup",):
        if f"/{extra}<" not in s:
            s = s.replace("</urlset>", f"  <url><loc>{SITE}/{extra}</loc><lastmod>2026-10-25</lastmod></url>\n</urlset>")
    write("sitemap.xml", s)


def main():
    if "order" not in CONTENT:
        sys.exit("data/content.json is missing the 'order' key")
    for c, _ in CATS:
        build_category(c)
    for p in PRODUCTS:
        build_product(p)
    build_home()
    build_shipping()
    build_checkout()
    swap_chrome("contact.html")
    swap_chrome("financing.html")
    build_sitemap()
    missing = [p["id"] for p in PRODUCTS if not buyable(p)]
    print(f"Built {len(PRODUCTS)} product pages, {len(CATS)} category pages, home, checkout, shipping.")
    if missing:
        print("Not purchasable online (no price yet):", ", ".join(missing))


if __name__ == "__main__":
    main()

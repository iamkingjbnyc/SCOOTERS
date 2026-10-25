# NYC ATV Warehouse storefront

Static site (Cloudflare) with a cart, three fulfillment options (ship, local delivery, free pickup)
and Stripe checkout via `worker/`.

- **Change prices:** edit `data/products.json`, then `python3 scripts/build_store.py`
- **Shipping / delivery settings:** `data/store.json`
- **Specs / photos / descriptions:** `data/content.json`
- **Go-live steps:** `worker/README.md`

Pages under `scooters/ atvs/ dirtbikes/ gokarts/ utvs/ ebikes/` and the category pages are generated;
edit the data files rather than the HTML. (The old `scripts/generate-*.ps1` generators target the
previous design and should not be re-run.)

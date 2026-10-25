# Online checkout (Stripe) — setup

The storefront runs in **preview mode** until `checkoutEndpoint` in `data/store.json` is set.
Nothing charges a card while it is empty.

## Go-live checklist
1. **Confirm the numbers** in `data/store.json` (everything marked `_confirm`): shipping rate per
   vehicle type, local delivery fee, local delivery ZIP prefixes, max quantity per item.
2. **Set real prices** in `data/products.json`, then run `python3 scripts/build_store.py`.
3. **Sales tax:** decide with your accountant how to charge it (NJ pickup/delivery vs. out-of-state
   shipping differ). Create a tax rate in Stripe and set `STRIPE_TAX_RATE_ID`, or enable Stripe Tax.
4. **Deploy this Worker** (`cd worker && npx wrangler deploy`), then add the secret:
   `npx wrangler secret put STRIPE_SECRET_KEY` — use a **test** key (`sk_test_...`) first.
5. Put the Worker URL in `data/store.json` → `"checkoutEndpoint": "https://nycatv-checkout.<you>.workers.dev"`.
6. Place a test order with Stripe's test card `4242 4242 4242 4242`. Check it in the Stripe dashboard.
7. Swap in the live key (`sk_live_...`) and update the webhook (`scripts/stripe-webhook-worker.js`)
   so new orders post to Slack with fulfillment details.

The Worker re-reads prices from the live site and recomputes totals itself, so a customer cannot
change a price in their browser.

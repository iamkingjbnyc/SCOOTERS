# Online card payments (Stripe) — setup

How payment works once connected:
- **Free pickup and free local delivery:** customer pays a **$100 deposit** online (amount is `deposit.amount`
  in `data/store.json`); the balance is collected at pickup/delivery.
- **Shipping:** customer pays the **full amount** (items + shipping) online.

Until `checkoutEndpoint` in `data/store.json` is filled in, the site stays in "Send my order" mode
(orders are emailed to sales@ and you take payment by phone). Nothing charges a card.

## Connect Stripe (about 10 minutes)
1. **Stripe:** in the Stripe dashboard turn on **Test mode** and copy your **Secret key** (`sk_test_...`).
   Keep it private — never paste it into chat, GitHub, or the website.
2. **Cloudflare:** Workers & Pages → **Create** → **Hello World** → name it `nycatv-checkout` → **Deploy**
   → **Edit code** → delete everything → paste the contents of `worker/checkout-worker.js` → **Deploy**.
3. In that Worker → **Settings → Variables and Secrets**, add:
   - Variable `SITE_ORIGIN` = `https://nycatvwarehouse.com`
   - Variable `ALLOWED_ORIGINS` = `https://nycatvwarehouse.com,https://www.nycatvwarehouse.com`
   - **Secret** `STRIPE_SECRET_KEY` = your `sk_test_...` key
4. Copy the Worker's URL (looks like `https://nycatv-checkout.<name>.workers.dev`) and send it to Claude
   (or set `"checkoutEndpoint"` in `data/store.json` and run `python3 scripts/build_store.py`).
5. **Test:** place an order with Stripe's test card `4242 4242 4242 4242` (any future date, any CVC).
   Try one pickup order (should charge $100) and one shipping order (should charge the full amount).
6. **Go live with real cards:** in Stripe switch off Test mode, copy the **live** secret key (`sk_live_...`),
   replace the `STRIPE_SECRET_KEY` secret in Cloudflare, and place one real small order to confirm.

## Slack alerts (optional)
`scripts/stripe-webhook-worker.js` posts new orders to Slack, including how it's fulfilled and any
balance due. Deploy it the same way and add its URL in Stripe → Developers → Webhooks
(event `checkout.session.completed`).

## Things to decide before real money
- **Deposit refund policy:** say whether the $100 deposit is refundable and put it on the site.
- **Sales tax:** not added automatically. Ask your accountant; then set `STRIPE_TAX_RATE_ID` (shipping orders)
  or collect tax on the balance at pickup/delivery.
- **Shipping rates and local ZIPs** in `data/store.json` are placeholders until you confirm them.

The Worker re-reads prices from the live site and recomputes every amount itself, so a customer cannot
change a price or the deposit in their browser.

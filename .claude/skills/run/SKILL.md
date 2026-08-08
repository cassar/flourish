---
name: run
description: Launch and drive Flourish (this Rails app) locally to verify a change actually works — sign in, view membership. Use before reporting a UI/feature change as done.
---

# Running Flourish

Rails 8 app, SQLite, Devise auth. Membership platform: members view
contributions/dividends/notifications; admins manage members.

## Starting the app

Local DNS/reverse-proxy is set up machine-wide: `http://flourish.test`
always proxies to port 3001, where this app's `bin/dev` defaults to running.
**Never blindly kill/restart a server** — Luke's own `bin/dev` may already
be running there. Check first and reuse it if so:

```bash
curl -sf -o /dev/null -w "%{http_code}\n" http://flourish.test
```

- **200/30x** → already running. Reuse it as-is (`http://flourish.test`),
  don't touch the process.
- **502** → Caddy is up but nothing bound to 3001. Safe to start a server
  yourself (below), and only kill what you started.
- **connection refused** → Caddy/dnsmasq isn't running; fall back to
  `http://localhost:3001` directly.

Only if nothing is running, start one in the background:

```bash
rm -f tmp/pids/server.pid
PORT=3001 bin/rails server -p 3001 -d
curl --retry 10 --retry-delay 1 --retry-connrefused -s http://localhost:3001/up
```

Stop with the PID file when done — only if you started it yourself:

```bash
kill $(cat tmp/pids/server.pid) 2>/dev/null; rm -f tmp/pids/server.pid
```

## Setup (idempotent)

```bash
bundle install
yarn install
bin/rails db:prepare
```

CSS/JS bundles: `bin/dev` runs the `yarn build` / `yarn build:css:dev`
watchers continuously. If assets look stale and you're not running the
watcher, build once:

```bash
yarn build
yarn build:css:dev
```

## Signing in

Devise-backed, at `/users/sign_in` (fields `user[email]` / `user[password]`).
An admin user is seeded by `db:seed`. In the existing dev database, that
admin's email was `admin@flourish.buzz` with the seeded password
`password` — **verify this against the live dev DB before relying on it**,
since it depends on `Rails.application.credentials.admin_email` and may
change:

```bash
sqlite3 storage/db/development.sqlite3 "select email, confirmed_at is not null from users;"
```

Only the admin account and users seeded with `user.confirm` are confirmed
and able to sign in — unconfirmed seeded users (roughly every 5th one) will
be bounced back to sign-in.

If no usable dev database exists yet:

```bash
bin/rails db:seed
```

## Driving the browser

No `chromium-cli` in this environment by default. Use Playwright directly —
install it in the scratchpad, not the repo, so it doesn't touch `package.json`:

```bash
mkdir -p /tmp/pw && cd /tmp/pw && npm init -y >/dev/null && npm install playwright
npx playwright install chromium
```

```js
const { chromium } = require("playwright");
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto("http://flourish.test/users/sign_in");
  await page.fill('input[name="user[email]"]', "admin@flourish.buzz");
  await page.fill('input[name="user[password]"]', "password");
  await page.click('input[type="submit"]');
  await page.waitForURL("**/membership");
  await page.screenshot({ path: "/tmp/pw/membership.png" });
  await browser.close();
})();
```

## Key pages

| Path | Purpose |
|---|---|
| `/users/sign_in` | Sign in |
| `/membership` | Member's own dividends/contributions overview |
| `/membership/dividends` | Dividend history |
| `/membership/contributions` | Contribution history |
| `/membership/notifications` | Notification preferences |
| `/admin/members` | Admin member list (admin only) |

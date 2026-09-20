# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Development
bin/dev                          # Full dev stack (Rails + JS + CSS watchers)

# Testing
bin/rails test                   # Run all tests
bin/rails test test/models/foo_test.rb           # Run single test file
bin/rails test test/models/foo_test.rb:42        # Run specific test at line

# Linting & Security
bundle exec rubocop              # Ruby style (uses Omakase config)
bundle exec brakeman             # Security scan
bundle exec bundler-audit        # Gem vulnerabilities

# Database
bin/rails db:setup               # Create + migrate + seed
bin/rails db:migrate             # Run pending migrations
```

## Production infrastructure

The app runs as a Docker container on a home server, managed by Kamal.

**This box also runs 4 other apps (focus_machine, skrol, bean_counter, cassar_constructions) plus Buildkite CI, all on the same 12 cores / ~24GB RAM.** Before changing memory limits, deploy/CI concurrency, or anything else that affects capacity, read `~/GitHub/cassar_code_infrastructure/CLAUDE.md` — changes scoped to this repo alone can still starve or crash the others.

**SSH access:**
```bash
ssh -i ~/.ssh/home-server ubuntu@100.115.240.52
# or, with the SSH config alias set up on the Mac:
ssh home-server
```

**Interact with the running app** (from this repo directory):
```bash
kamal console   # Rails console
kamal shell     # bash inside the container
kamal logs      # tail logs
kamal dbc       # database console
```

**Logs** (CloudWatch, via the default AWS profile):
```bash
aws logs tail /flourish/production --follow
```

**Deploy** (Buildkite triggers automatically on pushes to `main`; to deploy manually):
```bash
kamal deploy
```

## Observability & CI queries

**CI status** (Buildkite org `cassar-code-constructions`, pipeline `flourish` — pipeline slugs are hyphenated and don't always match the repo name; `bk` is pre-configured on the Mac):
```bash
bk build list --pipeline flourish                   # recent builds
bk build view <build-number> --pipeline flourish    # one build's steps/logs
bk agent list                                       # is home-1..home-6 online/busy right now
```

**Errors** (Honeybadger — querying needs `HONEYBADGER_READ_TOKEN`, a *personal auth token* exported in your shell profile on the Mac; this is separate from the project's write-side reporting key in `config/honeybadger.yml`, which can't be used to query the API):
```bash
# Find this app's project id (stable once looked up):
curl -s -u "$HONEYBADGER_READ_TOKEN:" https://app.honeybadger.io/v2/projects \
  | jq '.results[] | select(.name | test("Flourish"; "i")) | {id, name}'

# Recent unresolved errors:
curl -s -u "$HONEYBADGER_READ_TOKEN:" \
  "https://app.honeybadger.io/v2/projects/<project-id>/faults?q=is:unresolved"
```

Domain: flourish.buzz

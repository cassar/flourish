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

The app runs as a Docker container on a shared EC2 instance, managed by Kamal.

**This instance also runs 3 other apps (focus_machine, skrol, bean_counter) plus Buildkite CI, all competing for the same 2 vCPUs / 7.6GB RAM.** Before changing memory limits, deploy/CI concurrency, or anything else that affects capacity, read `~/GitHub/cassar_code_infrastructure/CLAUDE.md` — changes scoped to this repo alone can still starve or crash the others.

**SSH access:**
```bash
ssh -i ~/.ssh/cassar-code.pem ubuntu@52.62.31.62
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
export KAMAL_REGISTRY_PASSWORD=$(aws ecr get-login-password --region ap-southeast-2)
kamal deploy
```

Domain: flourish.buzz

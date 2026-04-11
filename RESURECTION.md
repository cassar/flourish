# Resurection — Approaches to bring from focus_machine

A focused list of patterns and tooling from the sister project [focus_machine](../focus_machine) worth adopting.

---

## 1. Pre-commit hooks via Lefthook

focus_machine uses [Lefthook](https://github.com/evilmartians/lefthook) to enforce quality gates before every commit.

**flourish already has** the security gems (`brakeman`, `bundler-audit`) and lint gem (`rubocop`) in the Gemfile — just no hook to run them.

### What to add

**`lefthook.yml`** in root:

```yaml
pre-commit:
  parallel: false
  commands:
    brakeman:
      tags: security
      run: bundle exec brakeman --no-pager --quiet
    bundler-audit:
      tags: security
      run: bundle exec bundler-audit
    rubocop:
      tags: lint
      glob: "*.rb"
      run: RUBOCOP_CACHE_ROOT=tmp/rubocop bundle exec rubocop -f github {staged_files}
    rails-test:
      tags: tests
      run: bin/rails db:test:prepare && bin/rails test
    system-test:
      tags: tests
      run: bin/rails test:system
```

Add gem and install hooks:
```ruby
# Gemfile (development group)
gem 'lefthook', require: false
```
```bash
bundle install && bundle exec lefthook install
```

Escape hatches (from focus_machine's `.githooks/pre-commit`):
```bash
LEFTHOOK=0 git commit                          # skip everything
LEFTHOOK_EXCLUDE=security,tests git commit     # skip specific groups
SKIP_PRE_COMMIT_TESTS=1 git commit             # skip just tests
```

---

## 2. SimpleCov with 100% line + branch coverage

focus_machine enforces 100% line and branch coverage via SimpleCov. This prevents dead code accumulating and catches untested branches early.

**flourish currently has** no coverage measurement at all.

### What to add

**`Gemfile`** (test group):
```ruby
gem 'simplecov', require: false
```

**`test/test_helper.rb`** — prepend before any other requires:
```ruby
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  merge_timeout 3600
  minimum_coverage line: 100, branch: 100

  add_group "Models",      "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services",    "app/services"
  add_group "Jobs",        "app/jobs"
  add_group "Helpers",     "app/helpers"

  # Exclude boilerplate
  add_filter "app/mailers/application_mailer.rb"
end
```

Wire up parallel test support (flourish already parallelises tests):
```ruby
parallelize_setup do |worker|
  SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
end

parallelize_teardown do
  SimpleCov.result
end
```

Add `coverage/` to `.gitignore`.

> Start by setting `minimum_coverage line: 80` and ratchet up. The goal is 100% — not all at once.

---

## 3. Tailwind CSS + DaisyUI

focus_machine uses Tailwind CSS 4 + DaisyUI 5 via esbuild/jsbundling-rails. flourish currently uses the classless Simple.css from a CDN.

DaisyUI gives production-ready component classes (buttons, cards, badges, modals, toasts) on top of Tailwind — same philosophy as Simple.css (semantic HTML) but far more capable.

### Migration path

1. Add gems:
```ruby
# Gemfile
gem 'jsbundling-rails'
gem 'cssbundling-rails'
# remove: gem 'importmap-rails', gem 'sprockets-rails', gem 'sassc-rails'
```

2. Add JS dependencies:
```json
{
  "dependencies": {
    "tailwindcss": "^4.1",
    "daisyui": "^5.5",
    "@tailwindcss/cli": "^4.2",
    "esbuild": "^0.28",
    "@hotwired/stimulus": "^3.2",
    "@hotwired/turbo-rails": "^8.0"
  }
}
```

3. Replace Simple.css CDN link with compiled Tailwind stylesheet and progressively convert markup to Tailwind/DaisyUI classes.

> This is the most effort of the three items — consider doing it on a feature branch and migrating views screen by screen.

---

## Notes

- All three can be done independently.
- Pre-commit hooks (#1) and SimpleCov (#2) are low-risk and high-value — good starting points.
- DaisyUI (#3) is a larger visual investment but eliminates the CDN dependency and unlocks a proper component system.

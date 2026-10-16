# Run using bin/ci (add -f / --fail-fast to stop at the first failure).
#
# Mirrors the Test, Lint and Audit steps in .buildkite/pipeline.yml so a local run
# catches what CI would. Buildkite stays the source of truth (it runs these as
# separate parallel steps, and deploys) - keep the two in sync when either changes.

CI.run do
  step "Setup", "bin/setup"
  step "Setup: JS", "yarn install --immutable"

  step "Style: Ruby", "bundle exec rubocop"

  step "Tests: Rails", "env RAILS_ENV=test bin/rails db:test:prepare test test:system"

  # Buildkite soft-fails its Audit step, so advisories are reported but don't fail the run.
  heading "Security: Gem audit (non-blocking)", "bundle exec bundler-audit check --update", type: :title
  unless system("bundle exec bundler-audit check --update")
    failure "Gem audit found advisories", "Non-blocking, same as Buildkite's soft_fail - review and update gems."
  end
end

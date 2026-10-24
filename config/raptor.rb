# frozen_string_literal: true

# Raptor web server config (https://github.com/joshuay03/raptor). Evaluated as a
# hash of options; RAPTOR_WORKERS / RAPTOR_THREADS / RAPTOR_MAX_THREADS env vars
# override these values.
#
# Solid Queue runs as its own Kamal role (bin/jobs), not from Raptor's hooks —
# see the Raptor README's note on SOLID_QUEUE_IN_PUMA.

threads = Integer(ENV.fetch("RAILS_MAX_THREADS", 2))

{
  # Raptor defaults to one worker per CPU (all of home-server's cores inside
  # Docker), which would blow the container memory limit. Production sets
  # RAPTOR_WORKERS explicitly in config/deploy.yml.
  workers: 1,
  threads: threads,
  # Fixed pool: adaptive growth would outrun the database connection pool
  # (max_connections in config/database.yml).
  max_threads: threads,
  # Reforking is off: on 0.20.1 a keep-alive connection held by the worker being
  # promoted to refork seed is never answered or closed, so a request sent on it
  # hangs. Matches pre-0.20.1 behaviour, where the handler ignored this key.
  refork_after: nil
}

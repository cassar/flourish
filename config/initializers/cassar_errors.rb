require "net/http"

class CassarErrorReporter
  TIMEOUT = 2

  def initialize(url)
    @uri = URI(url)
  end

  def report(error, handled:, severity:, context:, source: nil, **)
    return if ActionDispatch::ExceptionWrapper.rescue_responses.key?(error.class.name)

    deliver(
      error_class: error.class.name,
      message: error.message.to_s.truncate(2_000),
      backtrace: backtrace_for(error),
      context: context.to_h { |key, value| [ key, describe(value).truncate(500) ] },
      handled: handled,
      severity: severity,
      source: source,
      app: Rails.application.class.module_parent_name,
      environment: Rails.env
    )
  end

  private

  def describe(value)
    value.is_a?(AbstractController::Base) ? "#{value.class.name}##{value.action_name}" : value.to_s
  end

  def backtrace_for(error)
    lines = error.backtrace || []
    (Rails.backtrace_cleaner.clean(lines).presence || lines).first(30)
  end

  def deliver(payload)
    response = Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == "https",
      open_timeout: TIMEOUT, read_timeout: TIMEOUT, write_timeout: TIMEOUT) do |http|
      http.post(@uri.request_uri, payload.to_json, "Content-Type" => "application/json")
    end
    Rails.logger.warn("Cassar error report rejected: #{response.code}") unless response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    Rails.logger.warn("Cassar error report failed: #{e.class}: #{e.message}")
  end
end

if Rails.env.production? && (url = Rails.application.credentials.cassar_errors_url).present?
  Rails.error.subscribe(CassarErrorReporter.new(url))
end

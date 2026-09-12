# Rack::MethodOverride parses params before ActionDispatch::ShowExceptions is
# running, so a malformed body (e.g. bots sending UTF-16LE-encoded multipart
# params) raises Encoding::CompatibilityError straight past Rails' error
# handling and crashes with a 500. Guard against that here.
class MalformedEncodingGuard
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue Encoding::CompatibilityError
    [400, { 'Content-Type' => 'text/plain; charset=utf-8' }, ['Bad Request']]
  end
end

Rails.application.config.middleware.insert_before Rack::MethodOverride, MalformedEncodingGuard

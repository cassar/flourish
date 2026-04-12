class WebhookPoster
  include HTTParty

  class Error < StandardError; end

  def initialize(message)
    @message = message
  end

  def call
    config = WebhookConfiguration.instance
    return unless config.configured?

    response = self.class.post(
      config.url,
      headers: { 'Content-Type' => 'application/json' },
      body: { content: @message }.to_json
    )

    raise Error, "Webhook failed: #{response.body}" unless response.success?
  end
end

require 'test_helper'

class WebhookPosterTest < ActiveSupport::TestCase
  WEBHOOK_URL = 'https://example.com/webhooks/test-token'.freeze

  setup do
    @config = WebhookConfiguration.instance
    @config.update!(url: WEBHOOK_URL)
  end

  teardown do
    @config.update!(url: nil)
  end

  test 'posts message to configured webhook url' do
    stub = stub_request(:post, WEBHOOK_URL)
      .with(
        headers: { 'Content-Type' => 'application/json' },
        body: { content: 'Test message' }.to_json
      )
      .to_return(status: 200, body: '', headers: {})

    WebhookPoster.new('Test message').call

    assert_requested stub
  end

  test 'raises error on non-success response' do
    stub_request(:post, WEBHOOK_URL)
      .to_return(status: 400, body: 'Bad Request', headers: {})

    error = assert_raises WebhookPoster::Error do
      WebhookPoster.new('Test message').call
    end

    assert_match(/Webhook failed/, error.message)
  end

  test 'does nothing when webhook url is not configured' do
    @config.update!(url: nil)

    # No stub — would raise WebMock::NetConnectNotAllowedError if a request were made
    WebhookPoster.new('Test message').call

    assert_not_requested :post, WEBHOOK_URL
  end
end

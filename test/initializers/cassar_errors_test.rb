require 'test_helper'

class CassarErrorReporterTest < ActiveSupport::TestCase
  URL = 'https://example.com/inboxes/test-token'.freeze

  setup do
    @reporter = CassarErrorReporter.new(URL)
  end

  test 'does not deliver IpSpoofAttackError, which is bot/scanner noise rather than an app bug' do
    # No stub — would raise WebMock::NetConnectNotAllowedError if a request were made
    @reporter.report(
      ActionDispatch::RemoteIp::IpSpoofAttackError.new('IP spoofing attack?!'),
      handled: false, severity: 'error', context: {}, source: 'application.action_dispatch'
    )

    assert_not_requested :post, URL
  end

  test 'delivers other unhandled errors' do
    stub = stub_request(:post, URL).to_return(status: 200)

    @reporter.report(
      RuntimeError.new('boom'),
      handled: false, severity: 'error', context: {}, source: 'application'
    )

    assert_requested stub
  end
end

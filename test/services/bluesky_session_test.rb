require 'test_helper'

class BlueskySessionTest < ActiveSupport::TestCase
  test 'access_token' do
    stub_request(:post, 'https://bsky.social/xrpc/com.atproto.server.createSession')
      .with(
        body: '{"identifier":"test_bluesky_handle","password":"test_bluesky_app_password"}',
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 200, body: '', headers: {})

    HTTParty::Response.any_instance.stubs(:parsed_response)
      .returns({ 'accessJwt' => 'test_bluesky_access_token' })

    assert_equal 'test_bluesky_access_token', BlueskySession.new.access_token
  end

  test 'access_token error' do
    stub_request(:post, 'https://bsky.social/xrpc/com.atproto.server.createSession')
      .with(
        body: '{"identifier":"test_bluesky_handle","password":"test_bluesky_app_password"}',
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 400, body: '', headers: {})

    error = assert_raises BlueskySession::Error do
      BlueskySession.new.access_token
    end

    assert_match(/Auth failed/, error.message)
  end
end

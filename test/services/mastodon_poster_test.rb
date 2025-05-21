require 'test_helper'

class BlueskyClientTest < ActiveSupport::TestCase
  test 'call' do
    stub_request(:post, 'https://mastodon.social/api/v1/statuses')
      .with(
        body: '{"status":"testing"}',
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer my_mastodon_access_token',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: '', headers: {})

    assert MastodonPoster.new('testing').call
  end
end

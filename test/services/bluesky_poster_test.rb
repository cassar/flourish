require 'test_helper'

class BlueskyPosterTest < ActiveSupport::TestCase
  setup do
    travel_to Time.utc(2023, 12, 25, 10, 0, 0)
    BlueskySession.any_instance.stubs(:access_token).returns('test_bluesky_access_token')
  end

  test 'post_text' do
    stub_request(:post, 'https://bsky.social/xrpc/com.atproto.repo.createRecord')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer test_bluesky_access_token',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby'
        },
        body: {
          repo: 'test_bluesky_handle',
          collection: 'app.bsky.feed.post',
          record: {
            type: 'app.bsky.feed.post',
            text: 'my test post',
            createdAt: '2023-12-25T10:00:00Z'
          }
        }.to_json
      ).to_return(status: 200, body: '', headers: {})

    assert BlueskyPoster.new('my test post').call
  end

  test 'post_text error' do
    stub_request(:post, 'https://bsky.social/xrpc/com.atproto.repo.createRecord')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer test_bluesky_access_token',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby'
        },
        body: {
          repo: 'test_bluesky_handle',
          collection: 'app.bsky.feed.post',
          record: {
            type: 'app.bsky.feed.post',
            text: 'my test post',
            createdAt: '2023-12-25T10:00:00Z'
          }
        }.to_json
      ).to_return(status: 400, body: '', headers: {})

    error = assert_raises BlueskyPoster::Error do
      BlueskyPoster.new('my test post').call
    end

    assert_match(/Poster failed/, error.message)
  end
end

class BlueskyPoster
  include HTTParty
  include Bluesky

  base_uri 'https://bsky.social/xrpc'

  class Error < StandardError; end

  attr_reader :text

  def initialize(text)
    @text = text
  end

  def call
    response = self.class.post('/com.atproto.repo.createRecord', headers:, body:)

    return true if response.success?

    raise Error, "Poster failed: #{response.body}"
  end

  private

  def headers
    {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => 'application/json'
    }
  end

  def body
    {
      repo: HANDLE,
      collection: 'app.bsky.feed.post',
      record: {
        type: 'app.bsky.feed.post',
        text: text,
        createdAt: Time.now.utc.iso8601
      }
    }.to_json
  end

  def access_token
    BlueskySession.new.access_token
  end
end

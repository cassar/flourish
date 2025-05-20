class BlueskyPoster
  include HTTParty
  include Bluesky

  base_uri 'https://bsky.social/xrpc'

  class Error < StandardError; end

  attr_reader :original_text

  def initialize(original_text)
    @original_text = original_text
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
      record:
    }.to_json
  end

  def record
    return record_with_no_facets if facets.empty?

    record_with_no_facets.merge(facets:)
  end

  def record_with_no_facets
    {
      '$type': 'app.bsky.feed.post',
      text:,
      createdAt: Time.now.utc.iso8601
    }
  end

  def facets
    BlueskyLinkFacetCollector.new(original_text).call
  end

  def text
    BlueskyLinkFacetParser.new(original_text).plain_text
  end

  def access_token
    BlueskySession.new.access_token
  end
end

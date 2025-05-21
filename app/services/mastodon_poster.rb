class MastodonPoster
  include HTTParty
  base_uri 'https://mastodon.social'

  attr_reader :status

  ACCESS_TOKEN = ENV.fetch('MASTODON_ACCESS_TOKEN', 'my_mastodon_access_token')

  def initialize(message)
    @status = message
  end

  def call
    self.class.post('/api/v1/statuses', headers:, body:)
  end

  private

  def headers
    {
      'Authorization' => "Bearer #{ACCESS_TOKEN}",
      'Content-Type' => 'application/json'
    }
  end

  def body
    { status: }.to_json
  end
end

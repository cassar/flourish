class MastodonPoster
  include HTTParty

  base_uri 'https://mastodon.social'

  attr_reader :status

  ACCESS_TOKEN = (Rails.application.credentials.dig(:mastodon, :access_token) || 'my_mastodon_access_token').freeze

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

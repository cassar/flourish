class BlueskySession
  include HTTParty
  include Bluesky

  base_uri BASE_URI

  class Error < StandardError; end

  def access_token
    ENV['BLUESKY_ACCESS_TOKEN'] || session['accessJwt']
  end

  private

  def session
    response = create_session

    return response.parsed_response if response.success?

    raise Error, "Auth failed: #{response.body}"
  end

  def create_session
    self.class.post('/com.atproto.server.createSession', body:, headers:)
  end

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def body
    { identifier: HANDLE, password: APP_PASSWORD }.to_json
  end
end

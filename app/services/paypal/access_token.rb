class Paypal::AccessToken
  def self.call
    JSON.parse(response.body).dig('access_token')
  end

  private

  def self.response
    Excon.post(ENV['paypal_access_token_url'],
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      user: ENV['paypal_client_id'],
      password: ENV['paypal_client_secret'],
      body: URI.encode_www_form(
        grant_type: 'client_credentials'
      )
    )
  end
end

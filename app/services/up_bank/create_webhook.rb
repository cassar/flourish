module UpBank
  class CreateWebhook
    def call
      Rails.cache.write(UpBank::WEBHOOK_SECRET_KEY_CACHE_KEY, secret_key)
    end

    private

    def secret_key
      result.dig('data', 'attributes', 'secretKey')
    end

    def result
      JSON.parse(response.body)
    end

    def response
      Excon.post(url, headers:, body:)
    end

    def url
      'https://api.up.com.au/api/v1/webhooks'
    end

    def headers
      { 'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json' }
    end

    def body
      data.to_json
    end

    def access_token
      UpBank::ACCESS_TOKEN
    end

    def data
      {
        data: {
          attributes: {
            url: UpBank::WEBHOOK_URL,
            description: "webhook for #{UpBank::DOMAIN}"
          }
        }
      }
    end
  end
end

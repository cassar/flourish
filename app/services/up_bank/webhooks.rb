module UpBank
  class Webhooks
    class Error < StandardError; end

    def call
      raise Error, error_message unless response.status == 200

      result['data']
    end

    private

    def result
      JSON.parse(response.body)
    end

    def response
      @response ||= Excon.get(url, headers:, query: params)
    end

    def url
      'https://api.up.com.au/api/v1/webhooks'
    end

    def headers
      { 'Authorization' => "Bearer #{access_token}" }
    end

    def params
      { 'page[size]' => 1 }
    end

    def error_message
      "Error: #{response.status}, body: #{response.body}"
    end

    def access_token
      UpBank::ACCESS_TOKEN
    end
  end
end

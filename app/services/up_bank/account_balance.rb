module UpBank
  class AccountBalance
    class Error < StandardError; end

    def call
      raise Error, error_message unless response.status == 200

      result.dig('data', 'attributes', 'balance', 'valueInBaseUnits')
    end

    private

    def result
      JSON.parse(response.body)
    end

    def response
      @response ||= Excon.get(url, headers:)
    end

    def url
      "https://api.up.com.au/api/v1/accounts/#{account_number}"
    end

    def headers
      { 'Authorization' => "Bearer #{access_token}" }
    end

    def error_message
      "Error: #{response.status}, body: #{response.body}"
    end

    def access_token
      UpBank::ACCESS_TOKEN
    end

    def account_number
      UpBank::ACCOUNT_NUMBER
    end
  end
end

module UpBank
  class AccountTransactions
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
      @response ||= Excon.get(url, headers:, query: {})
    end

    def url
      "https://api.up.com.au/api/v1/accounts/#{account_number}/transactions"
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

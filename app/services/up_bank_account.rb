class UpBankAccount
  class Error < StandardError; end
  class NoCredentialsError < StandardError; end

  attr_reader :access_token, :account_number

  def initialize(access_token:, account_number:)
    @access_token = access_token
    @account_number = account_number
  end

  def balance
    Rails.cache.fetch('up_bank_balance', expires_in: 30.minutes) do
      request_balance
    end
  end

  private

  def request_balance
    raise NoCredentialsError if [access_token, account_number].any? nil

    raise Error, error_message unless response.status == 200

    dollars
  end

  def dollars
    cents / 100
  end

  def cents
    result.dig('data', 'attributes', 'balance', 'valueInBaseUnits')
  end

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
end

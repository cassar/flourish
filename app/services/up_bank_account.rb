class UpBankAccount
  class Error < StandardError; end
  class NoCredentialsError < StandardError; end

  attr_reader :access_token, :account_number

  def initialize(access_token:, account_number:)
    @access_token = access_token
    @account_number = account_number
  end

  def balance
    raise NoCredentialsError if [access_token, account_number].any? nil

    return dollars if response.status == 200

    raise Error, "Error: #{response.status}, body: #{response.body}"
  end

  private

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
end

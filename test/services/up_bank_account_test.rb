require 'test_helper'

class UpBankAccountTest < ActiveSupport::TestCase
  test 'balance with valid credentials and successful response' do
    stub_request(:get, 'https://api.up.com.au/api/v1/accounts/valid_account_number')
      .with(
        headers: {
          'Authorization' => 'Bearer valid_access_token',
          'Host' => 'api.up.com.au:443'
        }
      )
      .to_return(status: 200, body: '{"data": {"attributes": {"balance": {"valueInBaseUnits": 1000}}}}', headers: {})

    assert_equal 10,
                 UpBankAccount.new(access_token: 'valid_access_token', account_number: 'valid_account_number').balance
  end

  test 'balance with missing credentials' do
    assert_raises(UpBankAccount::NoCredentialsError) do
      UpBankAccount.new(access_token: nil, account_number: nil).balance
    end
  end

  test 'balance with invalid api response' do
    stub_request(:get, 'https://api.up.com.au/api/v1/accounts/valid_account_number')
      .with(
        headers: {
          'Authorization' => 'Bearer valid_access_token',
          'Host' => 'api.up.com.au:443'
        }
      )
      .to_return(status: 400, body: '', headers: {})

    assert_raises(UpBankAccount::Error) do
      UpBankAccount.new(access_token: 'valid_access_token', account_number: 'valid_account_number').balance
    end
  end
end

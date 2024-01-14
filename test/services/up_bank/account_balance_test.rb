require 'test_helper'

module UpBank
  class AccountBalanceTest < ActiveSupport::TestCase
    test 'on successful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/accounts/valid_account_number')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(status: 200, body: '{"data": {"attributes": {"balance": {"valueInBaseUnits": 10000}}}}', headers: {})

      assert_equal 10_000, UpBank::AccountBalance.new.call
    end

    test 'on unsuccessful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/accounts/valid_account_number')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(status: 400, body: 'sumulated bad requsted', headers: {})

      assert_raises(UpBank::AccountBalance::Error) do
        UpBank::AccountBalance.new.call
      end
    end
  end
end

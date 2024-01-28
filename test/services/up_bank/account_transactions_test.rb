require 'test_helper'

module UpBank
  class AccountTransactionsTest < ActiveSupport::TestCase
    test 'on successful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/accounts/valid_account_number/transactions')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(status: 200, body: '{"data": [1,2,3]}', headers: {})

      assert_equal [1, 2, 3], UpBank::AccountTransactions.new.call
    end

    test 'on unsuccessful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/accounts/valid_account_number/transactions')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(status: 400, body: '', headers: {})

      assert_raises(UpBank::AccountTransactions::Error) do
        UpBank::AccountTransactions.new.call
      end
    end
  end
end

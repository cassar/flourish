require 'test_helper'

class BankAccountServiceTest < ActiveSupport::TestCase
  test 'balance' do
    assert_equal 1000, BankAccountService.balance
  end

  test 'balance_formatted' do
    assert_equal '$1,000.00', BankAccountService.balance_formatted
  end
end

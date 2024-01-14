require 'test_helper'

class BankAccountServiceTest < ActiveSupport::TestCase
  setup do
    UpBank::AccountBalance.any_instance.stubs(:call).returns(10_000)
  end

  test 'balance' do
    assert_equal 10_000, BankAccountService.balance
  end

  test 'balance_formatted' do
    assert_equal '$100.00', BankAccountService.balance_formatted
  end
end

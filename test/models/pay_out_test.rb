require 'test_helper'
require_relative 'concerns/currency_validator_test'

class PayOutTest < ActiveSupport::TestCase
  include CurrencyValidatorTest

  test 'belongs to dividend association' do
    assert_equal dividends(:pay_out_complete), pay_outs(:pay_out_complete).dividend
  end

  test 'currency inclusion validation' do
    @currency_capable = pay_outs(:pending_pay_out)
    currency_inclusion_validation
  end
end

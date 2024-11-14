require 'test_helper'
require_relative 'concerns/currency_validator_test'

class PayOutTest < ActiveSupport::TestCase
  include CurrencyValidatorTest

  test 'belongs to dividend association' do
    assert_equal dividends(:pay_out_complete), pay_outs(:pay_out_complete).dividend
  end

  test 'transaction identifier validation' do
    error = assert_raises ActiveRecord::RecordInvalid do
      PayOut.new(
        amount_in_base_units: 500,
        transaction_identifier: pay_outs(:pay_out_complete).transaction_identifier
      ).save! 
    end

    assert_match(/Transaction ID has already been taken/, error.message)
  end

  test 'currency inclusion validation' do
    @currency_capable = pay_outs(:pay_out_complete)
    currency_inclusion_validation
  end
end

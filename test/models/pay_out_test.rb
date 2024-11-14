require 'test_helper'
require_relative 'concerns/currency_validator_test'

class PayOutTest < ActiveSupport::TestCase
  include CurrencyValidatorTest

  test 'belongs to dividend association' do
    assert_equal dividends(:pay_out_complete), pay_outs(:pay_out_complete).dividend
  end

  test 'amount in base units non positive integers' do
    error = assert_raises ActiveRecord::RecordInvalid do
      pay_outs(:pay_out_complete).update!(
        amount_in_base_units: 0
      )
    end

    expected_error = 'Validation failed: Amount in base units must be greater than 0'

    assert_equal expected_error, error.message
  end

  test 'fees in base units negative integers' do
    error = assert_raises ActiveRecord::RecordInvalid do
      pay_outs(:pay_out_complete).update!(
        fees_in_base_units: -1
      )
    end

    expected_error = 'Validation failed: Fees in base units must be greater than or equal to 0'

    assert_equal expected_error, error.message
  end

  test 'fees in base units default value' do
    assert_equal 0, PayOut.new.fees_in_base_units
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

  test 'amount_formatted' do
    assert_equal 100, pay_outs(:pay_out_complete).amount_in_base_units

    assert_equal '$1.00 AUD', pay_outs(:pay_out_complete).amount_formatted
  end

  test 'fees_formatted' do
    assert_equal 0, pay_outs(:pay_out_complete).fees_in_base_units

    assert_equal '$0.00 AUD', pay_outs(:pay_out_complete).fees_formatted
  end
end

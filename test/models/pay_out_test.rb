require 'test_helper'
require_relative 'concerns/currency_validator_test'
require_relative 'concerns/monetary_transaction_test'

class PayOutTest < ActiveSupport::TestCase
  include CurrencyValidatorTest
  include MonetaryTransactionTest

  test 'belongs to dividend association' do
    assert_equal dividends(:paid_out), pay_outs(:pay_out_complete).dividend
  end

  test 'amount in base units non positive integers' do
    @monetary_transaction = pay_outs(:pay_out_complete)
    amount_in_base_units_non_positive_validation
  end

  test 'fees in base units negative integers' do
    @monetary_transaction = pay_outs(:pay_out_complete)
    fees_in_base_units_negative_validation
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
    @monetary_transaction = pay_outs(:pay_out_complete)
    amount_formatted_validation(100, '$1.00 AUD')
  end

  test 'fees_formatted' do
    @monetary_transaction = pay_outs(:pay_out_complete)
    fees_formatted_validation(0, '$0.00 AUD')
  end

  test 'logs activity after creation' do
    assert_difference 'ActivityLog.count' do
      dividends(:one).create_pay_out!(
        currency: 'AUD',
        amount_in_base_units: 5000,
        fees_in_base_units: 0,
        transaction_identifier: 'pay_out_activity_log_test'
      )
    end

    assert_match(/Payout of .* completed/, ActivityLog.last.message)
  end
end

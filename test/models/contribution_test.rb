require 'test_helper'
require_relative 'concerns/currency_validator_test'
require_relative 'concerns/monetary_transaction_test'

class ContributionTest < ActiveSupport::TestCase
  include CurrencyValidatorTest
  include MonetaryTransactionTest

  test 'belongs to member association' do
    assert_equal members(:one), contributions(:one).member
  end

  test 'belongs to distribution association' do
    assert_equal distributions(:one), contributions(:one).distribution
  end

  test 'optional for distribution' do
    assert_nothing_raised do
      contributions(:one).update! distribution: nil
    end
  end

  test 'amount in base units non positive integers' do
    @monetary_transaction = contributions(:one)
    amount_in_base_units_non_positive_validation
  end

  test 'fees in base units negative integers' do
    @monetary_transaction = contributions(:one)
    fees_in_base_units_negative_validation
  end

  test 'fees in base units default value' do
    assert_equal 0, Contribution.new.fees_in_base_units
  end

  test 'transaction identifier validation' do
    error = assert_raises ActiveRecord::RecordInvalid do
      contributions(:two).update! transaction_identifier: contributions(:one).transaction_identifier
    end

    assert_match(/Transaction ID has already been taken/, error.message)
  end

  test 'currency inclusion validation' do
    @currency_capable = contributions(:one)
    currency_inclusion_validation
  end

  test 'amount_formatted' do
    @monetary_transaction = contributions(:one)
    amount_formatted_validation(100, '$1.00 AUD')
  end

  test 'fees_formatted' do
    @monetary_transaction = contributions(:one)
    fees_formatted_validation(10, '$0.10 AUD')
  end

  test 'gross_amount_formatted' do
    assert_equal 100, contributions(:one).amount_in_base_units
    assert_equal 10, contributions(:one).fees_in_base_units

    assert_equal '$1.10 AUD', contributions(:one).gross_amount_formatted
  end

  test 'created_at_formatted' do
    assert_equal 'Mon, 14th Oct 2024', contributions(:one).created_at_formatted
  end

  test 'logs activity after creation' do
    assert_difference 'ActivityLog.count' do
      members(:one).contributions.create!(
        currency: 'AUD',
        amount_in_base_units: 5000,
        fees_in_base_units: 0,
        transaction_identifier: 'activity_log_test_txn',
        pod: pods(:member_one_contributions)
      )
    end

    assert_match(/Contribution of .* received/, ActivityLog.last.message)
  end
end

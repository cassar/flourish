require 'test_helper'
require_relative 'concerns/currency_validator_test'

class ContributionTest < ActiveSupport::TestCase
  include CurrencyValidatorTest

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
    error = assert_raises ActiveRecord::RecordInvalid do
      contributions(:one).update!(
        amount_in_base_units: 0
      )
    end

    expected_error = 'Validation failed: Amount in base units must be greater than 0'

    assert_equal expected_error, error.message
  end

  test 'fees in base units negative integers' do
    error = assert_raises ActiveRecord::RecordInvalid do
      contributions(:one).update!(
        fees_in_base_units: -1
      )
    end

    expected_error = 'Validation failed: Fees in base units must be greater than or equal to 0'

    assert_equal expected_error, error.message
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
    assert_equal 100, contributions(:one).amount_in_base_units

    assert_equal '$1.00 AUD', contributions(:one).amount_formatted
  end

  test 'fees_formatted' do
    assert_equal 10, contributions(:one).fees_in_base_units

    assert_equal '$0.10 AUD', contributions(:one).fees_formatted
  end

  test 'gross_amount_formatted' do
    assert_equal 100, contributions(:one).amount_in_base_units
    assert_equal 10, contributions(:one).fees_in_base_units

    assert_equal '$1.10 AUD', contributions(:one).gross_amount_formatted
  end

  test 'created_at_formatted' do
    assert_equal 'Mon, 14th Oct 2024', contributions(:one).created_at_formatted
  end
end

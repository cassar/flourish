require 'test_helper'

class ContributionTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal members(:one), contributions(:one).member
  end

  test 'up bank uniqueness validation' do
    error = assert_raises ActiveRecord::RecordInvalid do
      contributions(:one).update!(
        up_bank_transaction_reference: contributions(:two).up_bank_transaction_reference
      )
    end

    expected_error = 'Validation failed: Up bank transaction reference has already been taken'
    assert_equal expected_error, error.message
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
end

require 'test_helper'

class ContributionTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal members(:one), contributions(:one).member
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

  test 'amount_formatted' do
    assert_equal 100, contributions(:one).amount_in_base_units

    assert_equal '$1.00 AUD', contributions(:one).amount_formatted
  end
end

require 'test_helper'

class ContributionTest < ActiveSupport::TestCase
  test 'belongs to member association' do
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
end

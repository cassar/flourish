require 'test_helper'

module MonetaryTransactionTest
  def amount_in_base_units_non_positive_validation
    error = assert_raises ActiveRecord::RecordInvalid do
      @monetary_transaction.update!(amount_in_base_units: 0)
    end

    expected_error = 'Validation failed: Amount in base units must be greater than 0'

    assert_equal expected_error, error.message
  end

  def fees_in_base_units_negative_validation
    error = assert_raises ActiveRecord::RecordInvalid do
      @monetary_transaction.update!(fees_in_base_units: -1)
    end

    expected_error = 'Validation failed: Fees in base units must be greater than or equal to 0'

    assert_equal expected_error, error.message
  end

  def amount_formatted_validation(expected_base_units, expected_formatted)
    assert_equal expected_base_units, @monetary_transaction.amount_in_base_units
    assert_equal expected_formatted, @monetary_transaction.amount_formatted
  end

  def fees_formatted_validation(expected_base_units, expected_formatted)
    assert_equal expected_base_units, @monetary_transaction.fees_in_base_units
    assert_equal expected_formatted, @monetary_transaction.fees_formatted
  end
end

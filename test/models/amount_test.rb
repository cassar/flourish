require 'test_helper'
require_relative 'concerns/currency_validator_test'

class AmountTest < ActiveSupport::TestCase
  include CurrencyValidatorTest

  test 'belongs to distribution association' do
    assert_equal distributions(:one), amounts(:one).distribution
  end

  test 'has many dividends' do
    assert_includes amounts(:one).dividends, dividends(:one)

    amounts(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end

  test 'currency inclusion validation' do
    @currency_capable = amounts(:one)
    currency_inclusion_validation
  end

  test 'amount formatted' do
    assert_equal 500, amounts(:one).amount_in_base_units

    assert_equal '$5.00 AUD', amounts(:one).amount_formatted
  end
end

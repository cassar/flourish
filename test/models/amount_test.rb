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
    result = Amount.new(amount_in_base_units: 500).amount_formatted

    assert_equal '$5.00 AUD', result
  end

  test 'currency_name' do
    assert_equal 'Australian Dollar', Amount.new.currency_name
  end
end

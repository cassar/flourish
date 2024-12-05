require 'test_helper'

class CurrencyConverterTest < ActiveSupport::TestCase
  test 'new with cached currencies' do
    Money.any_instance.stubs(:exchange_to).returns(5)
    CurrencyUpdaterService.stubs(:call).never

    assert CurrencyConverter.new(from_currency: 'AUD', amount_in_base_units: 567, to_currency: 'USD')
  end

  test 'new without cached currencies' do
    Money.any_instance.stubs(:exchange_to).raises(Money::Bank::UnknownRate)
    CurrencyUpdaterService.stubs(:call).once

    assert CurrencyConverter.new(from_currency: 'AUD', amount_in_base_units: 567, to_currency: 'USD')
  end

  test 'amount_in_base_units' do
    stub_eu_central_bank_request

    converter = CurrencyConverter.new(from_currency: 'AUD', amount_in_base_units: 567, to_currency: 'USD')

    assert_equal 372, converter.amount_in_base_units
  end

  test 'format' do
    stub_eu_central_bank_request

    converter = CurrencyConverter.new(from_currency: 'AUD', amount_in_base_units: 567, to_currency: 'USD')

    assert_equal '$3.72 USD', converter.format
  end
end

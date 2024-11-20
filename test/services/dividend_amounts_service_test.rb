require 'test_helper'

class DividendAmountsServiceTest < ActiveSupport::TestCase
  test 'returns an amount for each currency' do
    results = DividendAmountsService.new(
      amount_in_base_units: 500,
      currency: 'AUD'
    ).call

    assert_equal Currencies::SUPPORTED_CURRENCIES.count, results.length
  end

  test 'returns correct base units' do
    results = DividendAmountsService.new(
      amount_in_base_units: 500,
      currency: 'AUD'
    ).call

    aud_amount = results.find { |amount| amount.currency == 'AUD' }

    assert_equal 500, aud_amount.amount_in_base_units
  end
end

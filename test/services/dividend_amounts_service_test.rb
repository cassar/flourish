require 'test_helper'

class DividendAmountsServiceTest < ActiveSupport::TestCase
  test 'returns an amount for each currency' do
    stub_eu_central_bank_request

    results = DividendAmountsService.new(
      amount_in_base_units: 500,
      currency: 'AUD'
    ).call

    assert_equal Currencies::SUPPORTED.count, results.length
  end

  test 'returns correct base units' do
    stub_eu_central_bank_request

    results = DividendAmountsService.new(
      amount_in_base_units: 500,
      currency: 'AUD'
    ).call

    aud_amount = results.find { |amount| amount.currency == 'AUD' }

    assert_equal 500, aud_amount.amount_in_base_units
  end
end

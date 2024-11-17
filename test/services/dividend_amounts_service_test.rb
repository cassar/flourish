require 'test_helper'

class DividendAmountsServiceTest < ActiveSupport::TestCase
  test 'returns an amount for each currency' do
    result = DividendAmountsService.new(
      amount_in_base_units: 500,
      currency: 'AUD'
    ).call

    assert_equal Currencies::SUPPORTED_CURRENCIES.count, result.length
  end
end

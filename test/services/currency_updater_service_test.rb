require 'test_helper'

class CurrencyUpdaterServiceTest < ActiveSupport::TestCase
  test 'call' do
    stub_eu_central_bank_request

    assert CurrencyUpdaterService.call
  end
end

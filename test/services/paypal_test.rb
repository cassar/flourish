require 'test_helper'

class PaypalTest < ActiveSupport::TestCase
  test 'supported currencies constant' do
    assert_instance_of Array, Currencies::SUPPORTED_CURRENCIES
  end
end

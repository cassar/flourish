require 'test_helper'

module Admin
  class PayOutsHelperTest < ActionView::TestCase
    test 'paypalme_url with amount in base units' do
      expected = 'https://paypal.me/mypaypalmeid/5.50AUD'
      actual = paypalme_url(
        paypalmeid: 'mypaypalmeid',
        amount_in_base_units: 550
      )

      assert_equal expected, actual
    end

    test 'paypalme_url without amount in base units' do
      expected = 'https://paypal.me/mypaypalmeid'
      actual = paypalme_url(
        paypalmeid: 'mypaypalmeid'
      )

      assert_equal expected, actual
    end
  end
end

require 'test_helper'

module Admin
  class PayOutsHelperTest < ActionView::TestCase
    test 'paypalme_url with amount in base units' do
      expected = 'https://paypal.me/mypaypalme_handle/5.50AUD'
      actual = paypalme_url(
        paypalme_handle: 'mypaypalme_handle',
        amount_in_base_units: 550
      )

      assert_equal expected, actual
    end

    test 'paypalme_url with amount in base units and currency' do
      expected = 'https://paypal.me/mypaypalme_handle/550JPY'
      actual = paypalme_url(
        paypalme_handle: 'mypaypalme_handle',
        amount_in_base_units: 550,
        currency: 'JPY'
      )

      assert_equal expected, actual
    end

    test 'paypalme_url without amount in base units' do
      expected = 'https://paypal.me/mypaypalme_handle'
      actual = paypalme_url(
        paypalme_handle: 'mypaypalme_handle'
      )

      assert_equal expected, actual
    end
  end
end

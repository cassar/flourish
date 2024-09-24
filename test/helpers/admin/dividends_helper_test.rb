require 'test_helper'

module Admin
  class DividendsHelperTest < ActionView::TestCase
    test 'paypalme_url' do
      expected = 'https://paypal.me/mypaypalmeid/5.50AUD'
      actual = paypalme_url(
        paypalmeid: 'mypaypalmeid',
        amount_in_base_units: 550
      )

      assert_equal expected, actual
    end
  end
end

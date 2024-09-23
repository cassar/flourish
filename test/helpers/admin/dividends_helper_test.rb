require 'test_helper'

module Admin
  class DividendsHelperTest < ActionView::TestCase
    test 'paypalme_url' do
      expected = 'https://paypal.me/mypaypalmeid/5.50AUD?note=Flourish+Dividend+ID%3A+456'
      actual = paypalme_url(
        paypalmeid: 'mypaypalmeid',
        amount_in_base_units: 550,
        dividend_id: 456
      )

      assert_equal expected, actual
    end
  end
end

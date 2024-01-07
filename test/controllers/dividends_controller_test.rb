require 'test_helper'

class DividendsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @member = @user.member
    @dividend = dividends(:one)
    @payed_out_dividend = dividends(:pending_pay_out)
    @not_my_dividend = dividends(:two)
  end

  test 'should redirect to sign in when not authenticated for pay out' do
    sign_out @user
    patch pay_out_dividend_path(@dividend)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect back to dividends if not authorised' do
    assert_not_equal @not_my_dividend.member, @member

    patch pay_out_dividend_path(@not_my_dividend)

    assert_redirected_to dividends_path
    assert_equal 'That\'s not your dividend. 🤨', flash[:alert]
    assert @not_my_dividend.reload.issued?
  end

  test 'should redirect back to dividends if not in issued state' do
    assert @payed_out_dividend.pending_pay_out?

    patch pay_out_dividend_path(@payed_out_dividend)

    assert_redirected_to dividends_path
    assert_equal 'Dividend has already been marked for payed out.', flash[:alert]
    assert @payed_out_dividend.reload.pending_pay_out?
  end

  test 'should update dividend to pay out' do
    assert @dividend.issued?
    assert_equal @dividend.member, @member

    patch pay_out_dividend_path(@dividend)

    assert_redirected_to dividends_path
    assert_equal 'This Dividend has been marked for pay out.', flash[:notice]
    assert @dividend.reload.pending_pay_out?
  end
end

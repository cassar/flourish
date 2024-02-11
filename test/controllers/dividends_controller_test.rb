require 'test_helper'

class DividendsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @member = @user.member
    @dividend = dividends(:one)
    @payed_out_dividend = dividends(:pending_pay_out)
    @not_my_dividend = dividends(:issued)
  end

  test 'should redirect to sign in when not authenticated for dividends' do
    sign_out @user
    get dividends_path
    assert_redirected_to new_user_session_path
  end

  test 'should get dividends' do
    get dividends_path
    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for pay out' do
    sign_out @user
    patch pay_out_dividend_path(@dividend)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect back to dividends if not authorised for pay out' do
    assert_not_equal @not_my_dividend.member, @member

    patch pay_out_dividend_path(@not_my_dividend)

    assert_redirected_to dividends_path
    assert_equal 'That\'s not your dividend. 🤨', flash[:alert]
    assert @not_my_dividend.reload.issued?
  end

  test 'should redirect back to dividends if not in issued state for pay out' do
    assert @payed_out_dividend.pending_pay_out?

    patch pay_out_dividend_path(@payed_out_dividend)

    assert_redirected_to dividends_path
    assert_equal 'Dividend already updated.', flash[:alert]
    assert @payed_out_dividend.reload.pending_pay_out?
  end

  test 'should update dividend to pay out' do
    assert @dividend.issued?
    assert_equal @dividend.member, @member

    patch pay_out_dividend_path(@dividend)

    assert_redirected_to dividends_path
    assert_equal 'Dividend marked for pay out.', flash[:notice]
    assert @dividend.reload.pending_pay_out?
  end

  test 'should redirect to sign in when not authenticated for recontributed' do
    sign_out @user
    patch recontribute_dividend_path(@dividend)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect back to dividends if not authorised for recontributed' do
    assert_not_equal @not_my_dividend.member, @member

    patch recontribute_dividend_path(@not_my_dividend)

    assert_redirected_to dividends_path
    assert_equal 'That\'s not your dividend. 🤨', flash[:alert]
    assert @not_my_dividend.reload.issued?
  end

  test 'should redirect back to dividends if not in issued state for recontributed' do
    assert @payed_out_dividend.pending_pay_out?

    patch recontribute_dividend_path(@payed_out_dividend)

    assert_redirected_to dividends_path
    assert_equal 'Dividend already updated.', flash[:alert]
    assert @payed_out_dividend.reload.pending_pay_out?
  end

  test 'should update dividend to recontributed' do
    assert @dividend.issued?
    assert_equal @dividend.member, @member

    patch recontribute_dividend_path(@dividend)

    assert_redirected_to dividends_path
    assert_equal 'Dividend recontributed.', flash[:notice]
    assert @dividend.reload.recontributed?
  end
end

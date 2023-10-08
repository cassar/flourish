require 'test_helper'

class ActivationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
  end

  test 'should redirect to sign in when not authenticated for edit' do
    sign_out @user
    get edit_activation_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    get edit_activation_path(@user)
    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    sign_out @user
    put activation_path(@user)
    assert_redirected_to new_user_session_path
  end

  test "should update member's status to active" do
    put activation_path(@user)
    @user.reload
    assert @user.member.active?
  end

  test 'should redirect to root path after update' do
    put activation_path(@user)
    assert_redirected_to root_path
  end

  test 'should set flash success message after update' do
    put activation_path(@user)
    assert_equal I18n.t('controllers.activations.update.success'), flash[:success]
  end
end

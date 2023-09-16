require 'test_helper'

class ContributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @memberless_user = users(:no_member)
    @user_with_member = users(:one)
    @member = members(:active)
    @member_params = { member: { contribution_amount: 100 } }
  end

  test 'should redirect to sign-in when user is not signed in for new' do
    get new_contribution_url
    assert_redirected_to new_user_session_url
  end

  test 'should get new when user is signed in' do
    sign_in(@memberless_user)

    get new_contribution_url
    assert_response :success
  end

  test 'should create member contribution when user is signed in' do
    sign_in(@memberless_user)

    assert_difference('Member.count') do
      post contributions_url, params: @member_params
    end

    assert_redirected_to root_url
    assert_equal 'Member contribution created successfully.', flash[:success]
  end

  test 'should not create member contribution with invalid params when user is signed in' do
    sign_in(@memberless_user)

    assert_no_difference('Member.count') do
      post contributions_url, params: { member: { contribution_amount: -1 } }
    end

    assert_match 'Contribution amount must be greater than or equal to 0', flash[:error]
  end

  test 'should redirect to sign-in when user is not signed in for create' do
    post contributions_url, params: @member_params
    assert_redirected_to new_user_session_url
  end
  test 'should get edit when user is signed in' do
    sign_in(@user_with_member)
    get edit_contribution_url(@member)
    assert_response :success
  end

  test 'should not get edit when user is not signed in' do
    get edit_contribution_url(@member)
    assert_redirected_to new_user_session_url
  end

  test 'should update member contribution when user is signed in' do
    sign_in(@user_with_member)
    patch contribution_url(@member), params: { member: { contribution_amount: 200 } }
    assert_redirected_to root_url
    assert_equal 'Member contribution updated successfully.', flash[:success]
    @member.reload
    assert_equal 200, @member.contribution_amount
  end

  test 'should not update member contribution with invalid params when user is signed in' do
    sign_in(@user_with_member)
    patch contribution_url(@member), params: { member: { contribution_amount: nil } }
    assert_match 'Contribution amount is not a number', flash[:error]
    @member.reload
    assert_not_nil @member.contribution_amount
  end

  test 'should not update member contribution when user is not signed in' do
    patch contribution_url(@member), params: @member_params
    assert_redirected_to new_user_session_url
  end
end

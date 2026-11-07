require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest
  test 'root shows the redesign placeholder' do
    get root_path

    assert_response :success
    assert_includes response.body, 'Flourish is being redesigned.'
  end

  test 'sign in page renders with default devise views' do
    get new_user_session_path

    assert_response :success
  end

  test 'sign up is disabled' do
    assert_not_respond_to self, :new_user_registration_path
  end
end

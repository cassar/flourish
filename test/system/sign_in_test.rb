require 'application_system_test_case'

class SignInTest < ApplicationSystemTestCase
  test 'a signed-in user can open the home page' do
    sign_in_as users(:one)
    visit root_path

    assert_no_current_path new_user_session_path
  end
end

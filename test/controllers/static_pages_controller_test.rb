require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
  end

  test 'should get about' do
    get about_path
    assert_response :success
  end

  test 'should get check_email_spam' do
    get check_email_spam_path
    assert_response :success
  end
end

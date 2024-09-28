require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home when previous distribution with issued dividends' do
    assert Distribution.last
    assert Distribution.last.dividends.issued.any?

    get root_path
    assert_response :success
  end

  test 'should get home when last distribution is settled' do
    Distribution.destroy_all

    get root_path
    assert_response :success
  end

  test 'should get home when user authenticated' do
    sign_in users(:one)

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

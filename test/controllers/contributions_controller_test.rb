require 'test_helper'

class ContributionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get contribution_path(contributions(:one).uuid)

    assert_response :success
  end

  test 'should get show when signed in' do
    sign_in users(:one)

    get contribution_path(contributions(:one).uuid)

    assert_response :success
  end
end

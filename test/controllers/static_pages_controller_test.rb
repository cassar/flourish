require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'should get dashboard' do
    get root_path
    assert_response :success
  end
end

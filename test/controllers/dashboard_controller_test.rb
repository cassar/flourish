require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'should get dashboard' do
    TotalPoolService.stubs(:balance_formatted).returns('$133.00')

    get root_path
    assert_response :success
  end
end

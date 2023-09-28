require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'should get dashboard' do
    MemberGeneratorJob.stubs(:perform_now).once

    get root_path
    assert_response :success
  end
end

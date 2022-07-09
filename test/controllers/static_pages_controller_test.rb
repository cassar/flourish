require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    MemberGeneratorJob.stubs(:perform_now).once

    get root_path
    assert_response :success
  end
end

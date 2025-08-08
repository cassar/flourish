require 'test_helper'

class ContributionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get contribution_path(contributions(:one).uuid)

    assert_response :success
  end
end

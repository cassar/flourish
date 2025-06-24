require 'test_helper'

class CornersControllerTest < ActionDispatch::IntegrationTest
  test 'get nvc' do
    get nonviolent_communication_corners_path

    assert_response :success
  end
end

require 'test_helper'

class DistributionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get distributions_path
    assert_response :success
  end
end

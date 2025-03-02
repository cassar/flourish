require 'test_helper'

class DistributionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get distributions_path

    assert_response :success
  end

  test 'should get show' do
    get distribution_path(distributions(:one))

    assert_response :success
  end
end

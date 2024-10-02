require 'test_helper'

class NextDistributionNameServiceTest < ActiveSupport::TestCase
  test 'next distribution name' do
    assert_equal 2, Distribution.count

    assert_equal '#3', NextDistributionNameService.call
  end
end

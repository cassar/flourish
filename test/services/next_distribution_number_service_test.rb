require 'test_helper'

class NextDistributionNumberServiceTest < ActiveSupport::TestCase
  test 'next distribution number' do
    assert_equal 2, Distribution.count

    assert_equal 3, NextDistributionNumberService.call
  end
end

require 'test_helper'

class BlueskyNewDividendDistributionTest < ActiveSupport::TestCase
  test 'call renders the template and posts it' do
    BlueskyPoster.any_instance.stubs(:call).returns(true)

    assert BlueskyNewDividendDistribution.new(distribution: distributions(:one)).call
  end
end

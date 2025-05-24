require 'test_helper'

class BlueskyNewDividendDistributionTest < ActiveSupport::TestCase
  test 'call' do
    BlueskyPoster.any_instance.stubs(:call).returns(true)
    distribution = distributions(:one)

    assert BlueskyNewDividendDistribution.new(distribution:).call
  end
end

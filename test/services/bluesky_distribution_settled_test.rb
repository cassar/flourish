require 'test_helper'

class BlueskyDistributionSettledTest < ActiveSupport::TestCase
  test 'call' do
    BlueskyPoster.any_instance.stubs(:call).returns(true)
    distribution = distributions(:one)

    assert BlueskyDistributionSettled.new(distribution:).call
  end
end

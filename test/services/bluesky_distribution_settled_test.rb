require 'test_helper'

class BlueskyDistributionSettledTest < ActiveSupport::TestCase
  test 'call renders the template and posts it' do
    BlueskyPoster.any_instance.stubs(:call).returns(true)

    assert BlueskyDistributionSettled.new(distribution: distributions(:one)).call
  end
end

require 'test_helper'

class DistributionSettledNotificationServiceTest < ActiveSupport::TestCase
  test 'call emails users and posts to bluesky and mastodon when settled' do
    BlueskyDistributionSettled.any_instance.stubs(:call).returns(true)
    MastodonDistributionSettled.any_instance.stubs(:call).returns(true)
    ActionMailer::Base.deliveries.clear

    DistributionSettledNotificationService.new(
      distribution: distributions(:two),
      users: [users(:one)]
    ).call

    assert_equal 1, ActionMailer::Base.deliveries.count
  end

  test 'call raises when the distribution has not settled' do
    error = assert_raises DistributionSettledNotificationService::DistributionNotSettledError do
      DistributionSettledNotificationService.new(
        distribution: distributions(:one),
        users: [users(:one)]
      ).call
    end

    assert_instance_of DistributionSettledNotificationService::DistributionNotSettledError, error
  end
end

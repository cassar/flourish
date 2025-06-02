require 'test_helper'

class DistributionSettledNotificationServiceTest < ActiveSupport::TestCase
  test 'fails when distribution not settled' do
    distribution = distributions(:one)

    assert_predicate distribution.dividends.issued, :any?

    assert_raises DistributionSettledNotificationService::DistributionNotSettledError do
      DistributionSettledNotificationService.new(users: [], distribution:).call
    end
  end

  test 'sends notification to each member' do
    ActionMailer::Base.deliveries.clear
    users = [users(:one), users(:two)]
    distribution = distributions(:two)

    BlueskyDistributionSettled.any_instance.stubs(:call)
    MastodonDistributionSettled.any_instance.stubs(:call)

    DistributionSettledNotificationService.new(users:, distribution:).call

    assert_equal users.length, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/Distribution #2 has Settled/)
    end)
  end

  test 'posts to bluesky' do
    users = []
    distribution = distributions(:two)

    BlueskyDistributionSettled.any_instance.stubs(:call).once
    MastodonDistributionSettled.any_instance.stubs(:call)

    assert_nil DistributionSettledNotificationService.new(users:, distribution:).call
  end

  test 'posts to mastodon' do
    users = []
    distribution = distributions(:two)

    BlueskyDistributionSettled.any_instance.stubs(:call)
    MastodonDistributionSettled.any_instance.stubs(:call).once

    assert_nil DistributionSettledNotificationService.new(users:, distribution:).call
  end
end

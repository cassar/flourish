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

    DistributionSettledNotificationService.new(users:, distribution:).call

    assert_equal users.length, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/Distribution #2 has Settled/)
    end)
  end
end

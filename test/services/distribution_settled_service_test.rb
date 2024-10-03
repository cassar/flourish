require 'test_helper'

class DistributionSettledServiceTest < ActiveSupport::TestCase
  test 'sends a notification to each user' do
    users = [users(:one), users(:two)]
    distribution = distributions(:one)
    distribution.dividends.issued.destroy_all

    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:distribution_settled).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true).times(users.count)

    assert DistributionSettledService.new(users:, distribution:).call
  end

  test 'fails when distribution not settled' do
    distribution = distributions(:one)

    assert_predicate distribution.dividends.issued, :any?

    assert_raises DistributionSettledService::DistributionNotSettledError do
      DistributionSettledService.new(users: [], distribution:).call
    end
  end

  test 'all dependent services respond' do
    users = [users(:one)]
    distribution = distributions(:one)
    distribution.dividends.issued.destroy_all

    assert DistributionSettledService.new(users:, distribution:).call
  end
end

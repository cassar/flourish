require 'test_helper'

class DistributionPreviewServiceTest < ActiveSupport::TestCase
  test 'sends a notification to each user' do
    users = [users(:one), users(:two)]

    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:distribution_preview).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true).times(users.count)

    assert DistributionPreviewService.new(users:).call
  end

  test 'all dependent services respond' do
    assert DistributionPreviewService.new(users: [users(:one)]).call
  end
end

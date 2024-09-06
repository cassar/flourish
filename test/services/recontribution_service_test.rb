require 'test_helper'

class RecontributionServiceTest < ActiveSupport::TestCase
  test 'automatically recontributes all issued dividends' do
    Time.zone.stubs(:today).returns(Date.parse(RecontributionService::DAY_OF_THE_WEEK))

    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).with(dividend: dividends(:one)).returns(mailer_mock)
    NotificationMailer.stubs(:with).with(dividend: dividends(:issued)).returns(mailer_mock)
    mailer_mock.stubs(:dividend_recontributed_notification).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true)

    assert_not_empty Dividend.issued
    RecontributionService.new.call
    assert_empty Dividend.issued
  end

  test 'fails when not the day for automatic recontributions' do
    non_recontribution_day = 'Monday'
    assert_not_equal non_recontribution_day, RecontributionService::DAY_OF_THE_WEEK
    Time.zone.stubs(:today).returns(Date.parse(non_recontribution_day))

    assert_raises RecontributionService::NotTodayError do
      RecontributionService.new.call
    end
  end

  test 'all dependend services are called' do
    Time.zone.stubs(:today).returns(Date.parse(RecontributionService::DAY_OF_THE_WEEK))

    assert RecontributionService.new.call
  end
end

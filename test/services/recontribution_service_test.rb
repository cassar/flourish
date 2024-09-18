require 'test_helper'

class RecontributionServiceTest < ActiveSupport::TestCase
  test 'auto recontributes dividends on recontribution day ' do
    Time.zone.stubs(:today).returns(Date.parse(RecontributionService::DAY_OF_THE_WEEK))
    assert Dividend.issued.count < RecontributionService::BATCH_SIZE

    assert_equal 'issued', dividends(:issued).status
    RecontributionService.new.call
    assert_equal 'auto_recontributed', dividends(:issued).reload.status
  end

  test 'sends notification for each recontribution' do
    Time.zone.stubs(:today).returns(Date.parse(RecontributionService::DAY_OF_THE_WEEK))
    issued_dividends_count = Dividend.issued.count
    assert issued_dividends_count < RecontributionService::BATCH_SIZE

    assert RecontributionService.new.call

    assert_equal issued_dividends_count, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/Your Dividend has been Automatically Recontributed/)
    end)
  end

  test 'only does one batch at a time' do
    Time.zone.stubs(:today).returns(Date.parse(RecontributionService::DAY_OF_THE_WEEK))
    RecontributionService::BATCH_SIZE.times do
      distributions(:one).dividends.issued.create!(member: members(:one))
    end
    assert Dividend.issued.count > RecontributionService::BATCH_SIZE

    assert_difference 'Dividend.issued.count', -RecontributionService::BATCH_SIZE do
      RecontributionService.new.call
    end
  end

  test 'does nothing if not day for automatic recontributions' do
    non_recontribution_day = 'Monday'
    assert_not_equal non_recontribution_day, RecontributionService::DAY_OF_THE_WEEK
    Time.zone.stubs(:today).returns(Date.parse(non_recontribution_day))

    assert_no_difference 'Dividend.issued.count' do
      RecontributionService.new.call
    end
  end
end

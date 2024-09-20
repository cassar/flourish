require 'test_helper'

class RecontributionServiceTest < ActiveSupport::TestCase
  test 'auto recontributes dividends' do
    assert_equal 'issued', dividends(:issued).status

    RecontributionService.new(
      issued_dividends: [dividends(:issued)]
    ).call

    assert_equal 'auto_recontributed', dividends(:issued).reload.status
  end

  test 'sends notification for each auto recontribution' do
    ActionMailer::Base.deliveries.clear 

    assert RecontributionService.new(
      issued_dividends: [dividends(:issued)]
    ).call

    assert_equal 1, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/Your Dividend has been Automatically Recontributed/)
    end)
  end
end

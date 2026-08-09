require 'test_helper'

class RecontributionServiceTest < ActiveSupport::TestCase
  test 'auto recontributes dividends' do
    assert_equal 'issued', dividends(:issued).status

    RecontributionService.new(
      issued_dividends: [dividends(:issued)],
      notify_enabled_dividends: []
    ).call

    assert_equal 'auto_recontributed', dividends(:issued).reload.status
  end

  test 'notifies subscribed members' do
    ActionMailer::Base.deliveries.clear

    RecontributionService.new(
      issued_dividends: [dividends(:issued)],
      notify_enabled_dividends: [dividends(:issued)]
    ).call

    assert_equal 1, ActionMailer::Base.deliveries.count
  end
end

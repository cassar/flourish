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
end

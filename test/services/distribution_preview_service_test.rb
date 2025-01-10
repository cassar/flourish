require 'test_helper'

class DistributionPreviewServiceTest < ActiveSupport::TestCase
  test 'sends a notification to each user' do
    ActionMailer::Base.deliveries.clear
    stub_eu_central_bank_request
    users = [users(:one), users(:two)]

    DistributionPreviewService.new(users:).call

    assert_equal users.length, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/Distribution #3 Preview/)
    end)
  end
end

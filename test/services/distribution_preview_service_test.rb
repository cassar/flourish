require 'test_helper'

class DistributionPreviewServiceTest < ActiveSupport::TestCase
  test 'call emails each given user a distribution preview' do
    stub_eu_central_bank_request
    ActionMailer::Base.deliveries.clear

    DistributionPreviewService.new(users: [users(:one)]).call

    assert_equal 1, ActionMailer::Base.deliveries.count
  end
end

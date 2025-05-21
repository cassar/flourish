require 'test_helper'

class BlueskyDistributionPreviewTest < ActiveSupport::TestCase
  test 'call' do
    stub_eu_central_bank_request
    BlueskyPoster.any_instance.stubs(:call).returns(true)

    assert BlueskyDistributionPreview.new.call
  end
end

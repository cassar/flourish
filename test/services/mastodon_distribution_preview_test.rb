require 'test_helper'

class MastodonDistributionPreviewTest < ActiveSupport::TestCase
  test 'call' do
    stub_eu_central_bank_request
    MastodonPoster.any_instance.stubs(:call).returns(true)

    assert MastodonDistributionPreview.new.call
  end
end

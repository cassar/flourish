require 'test_helper'

class MastodonDistributionSettledTest < ActiveSupport::TestCase
  test 'call renders the template and posts it' do
    MastodonPoster.any_instance.stubs(:call).returns(true)

    assert MastodonDistributionSettled.new(distribution: distributions(:one)).call
  end
end

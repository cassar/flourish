require 'test_helper'

class MastodonDistributionSettledTest < ActiveSupport::TestCase
  test 'call' do
    MastodonPoster.any_instance.stubs(:call).returns(true)
    distribution = distributions(:one)

    assert MastodonDistributionSettled.new(distribution:).call
  end
end

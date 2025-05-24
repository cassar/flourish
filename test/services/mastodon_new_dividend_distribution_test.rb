require 'test_helper'

class MastodonNewDividendDistributionTest < ActiveSupport::TestCase
  test 'call' do
    MastodonPoster.any_instance.stubs(:call).returns(true)
    distribution = distributions(:one)

    assert MastodonNewDividendDistribution.new(distribution:).call
  end
end

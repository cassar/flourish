require 'test_helper'

class MastodonNewDividendDistributionTest < ActiveSupport::TestCase
  test 'call renders the template and posts it' do
    MastodonPoster.any_instance.stubs(:call).returns(true)

    assert MastodonNewDividendDistribution.new(distribution: distributions(:one)).call
  end
end

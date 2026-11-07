require 'test_helper'

class NextDistributionTest < ActiveSupport::TestCase
  setup do
    @next_distribution = NextDistribution.new(pod: pods(:general))
  end

  test 'distribute!' do
    stub_eu_central_bank_request

    assert_instance_of Distribution, @next_distribution.distribute!
  end

  test 'members' do
    assert @next_distribution.members
  end

  test 'member_count' do
    result = @next_distribution.member_count

    assert_instance_of Integer, result
  end

  test 'name' do
    result = @next_distribution.name

    assert_instance_of String, result
  end
end

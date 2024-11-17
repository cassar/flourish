require 'test_helper'

class MemberDividendServiceTest < ActiveSupport::TestCase
  test 'creates a dividend for each member' do
    members = [members(:one), members(:two)]
    amounts = [amounts(:one), amounts(:two)]

    assert_difference 'Dividend.count', members.count do
      MemberDividendService.new(members:, amounts:).call
    end

    dividend_members = Member.joins(:dividends).where(dividends: { amount: amounts })

    assert_includes dividend_members, members(:one)
    assert_includes dividend_members, members(:two)
  end

  test 'members is empty' do
    amounts = [amounts(:one)]

    assert_raises MemberDividendService::NoMembersError do
      MemberDividendService.new(members: [], amounts:).call
    end
  end

  test 'no amount' do
    members = [members(:one), members(:two)]

    assert_raises MemberDividendService::NoAmountError do
      MemberDividendService.new(members:, amounts: []).call
    end
  end

  test 'all dependent services respond' do
    members = [members(:one)]
    amounts = [amounts(:one)]

    assert MemberDividendService.new(members:, amounts:).call
  end
end

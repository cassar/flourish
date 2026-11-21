require 'test_helper'

class DividendTest < ActiveSupport::TestCase
  test 'belongs to member association' do
    assert_equal members(:one), dividends(:one).member
  end

  test 'belongs to amount association' do
    assert_equal amounts(:one), dividends(:one).amount
  end

  test 'has one distribution' do
    assert_equal distributions(:one), dividends(:one).distribution
  end

  test 'has one pay out association' do
    assert_equal pay_outs(:pay_out_complete), dividends(:paid_out).pay_out

    dividends(:paid_out).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      pay_outs(:pay_out_complete).reload
    end
  end

  test 'logs activity when status changes to pending_payout' do
    dividend = dividends(:paid_out)

    assert_difference 'ActivityLog.count' do
      dividend.update!(status: :pending_payout)
    end

    assert_match(/Payout requested by/, ActivityLog.last.message)
  end

  test 'does not log activity when status changes to paid_out' do
    dividend = dividends(:pending_payout)

    assert_no_difference 'ActivityLog.count' do
      dividend.update!(status: :paid_out)
    end
  end

  test "the contributor can't receive a dividend from their own distribution" do
    dividend = Dividend.new(amount: amounts(:three), member: members(:one))

    assert_not dividend.valid?
    assert_includes dividend.errors[:member], "can't receive a dividend from their own distribution"
  end

  test 'anyone else in the pot can receive a dividend from the distribution' do
    assert_predicate Dividend.new(amount: amounts(:three), member: members(:two)), :valid?
  end

  test 'a dividend missing its member or amount fails only on the missing association' do
    without_member = Dividend.new(amount: amounts(:three))
    without_amount = Dividend.new(member: members(:one))

    assert_not without_member.valid?
    assert_not without_amount.valid?
    assert_equal ['must exist'], without_member.errors[:member]
    assert_empty without_amount.errors[:member]
  end

  test 'defaults to pending payout' do
    assert_predicate Dividend.new, :pending_payout?
  end
end

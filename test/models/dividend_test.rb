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

  test 'defaults to pending payout' do
    assert_predicate Dividend.new, :pending_payout?
  end
end

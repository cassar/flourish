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
    assert_equal pay_outs(:pay_out_complete), dividends(:pay_out_complete).pay_out

    dividends(:pay_out_complete).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      pay_outs(:pay_out_complete).reload
    end
  end

  test 'owed scope' do
    assert_includes Dividend.owed, Dividend.pending_pay_out.first

    assert_not_includes Dividend.owed, Dividend.issued.first
    assert_not_includes Dividend.owed, Dividend.pay_out_complete.first
    assert_not_includes Dividend.owed, Dividend.manually_recontributed.first
    assert_not_includes Dividend.owed, Dividend.auto_recontributed.first
  end

  test 'recontributed scope' do
    assert_includes Dividend.recontributed, Dividend.issued.first
    assert_includes Dividend.recontributed, Dividend.manually_recontributed.first
    assert_includes Dividend.recontributed, Dividend.auto_recontributed.first

    assert_not_includes Dividend.recontributed, Dividend.pending_pay_out.first
    assert_not_includes Dividend.recontributed, Dividend.pay_out_complete.first
  end

  test 'automatically_recontributed_notify_enabled scope' do
    assert_includes Dividend.automatically_recontributed_notify_enabled, dividends(:one)

    assert_not_includes Dividend.automatically_recontributed_notify_enabled, dividends(:issued)
  end

  test 'logs activity when status changes to pending_pay_out' do
    dividend = dividends(:one)

    assert_difference 'ActivityLog.count' do
      dividend.update!(status: :pending_pay_out)
    end

    assert_match(/Payout requested by/, ActivityLog.last.message)
  end

  test 'logs activity when status changes to manually_recontributed' do
    dividend = dividends(:pending_pay_out)

    assert_difference 'ActivityLog.count' do
      dividend.update!(status: :manually_recontributed)
    end

    assert_match(/Dividend manually recontributed by/, ActivityLog.last.message)
  end

  test 'logs activity when status changes to auto_recontributed' do
    dividend = dividends(:pending_pay_out_two)

    assert_difference 'ActivityLog.count' do
      dividend.update!(status: :auto_recontributed)
    end

    assert_match(/Dividend automatically recontributed for/, ActivityLog.last.message)
  end

  test 'does not log activity when status changes to pay_out_complete' do
    dividend = dividends(:pending_pay_out)

    assert_no_difference 'ActivityLog.count' do
      dividend.update!(status: :pay_out_complete)
    end
  end

  test 'does not log activity when status changes to issued' do
    dividend = dividends(:pending_pay_out)

    assert_no_difference 'ActivityLog.count' do
      dividend.update!(status: :issued)
    end
  end
end

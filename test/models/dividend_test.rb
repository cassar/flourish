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
end

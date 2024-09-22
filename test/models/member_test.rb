require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'belongs to user association' do
    assert_equal users(:one), members(:one).user
  end

  test 'has many dividends association' do
    assert_includes members(:one).dividends, dividends(:one)
  end

  test 'dependend destroy relationship on dividends' do
    assert dividends(:one).present?
    members(:one).destroy

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end

  test 'has many contributions association' do
    assert_includes members(:one).contributions, contributions(:one)
  end

  test 'dependend destroy relationship on contributions' do
    assert contributions(:one).present?
    members(:one).destroy

    assert_raises ActiveRecord::RecordNotFound do
      contributions(:one).reload
    end
  end

  test 'enforces unique paypalmeid' do
    error = assert_raises ActiveRecord::RecordInvalid do
      members(:one).update! paypalmeid: members(:has_paypalmeid).paypalmeid
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'ignores unique validation when paypalmeid is nil' do
    members(:has_paypalmeid).update! paypalmeid: nil

    assert_nil members(:has_paypalmeid).reload.paypalmeid
  end

  test 'enforces case insensitive paypalmeid' do
    upcase_duplicate_paypalid = members(:has_paypalmeid).paypalmeid.upcase
    assert_not_equal upcase_duplicate_paypalid, members(:has_paypalmeid).paypalmeid

    error = assert_raises ActiveRecord::RecordInvalid do
      members(:one).update! paypalmeid: upcase_duplicate_paypalid
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'active scope' do
    assert_includes Member.active, members(:active)

    assert_not_includes Member.active, members(:admin)
    assert_not_includes Member.active, members(:inactive)
  end

  test 'pay outs disabled when no paypal.me id' do
    assert members(:one).pay_outs_disabled?
  end

  test 'pay outs enabled when paypal.me id present' do
    assert_not members(:has_paypalmeid).pay_outs_disabled?
  end
end

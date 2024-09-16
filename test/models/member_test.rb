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
    assert_not_nil members(:unconfirmed).paypalmeid

    error = assert_raises ActiveRecord::RecordInvalid do
      members(:one).update! paypalmeid: members(:unconfirmed).paypalmeid
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'ignores unique validation when paypalmeid is nil' do
    assert_nil members(:one).paypalmeid

    members(:unconfirmed).update! paypalmeid: nil

    assert_nil members(:unconfirmed).reload.paypalmeid
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
    assert_not members(:unconfirmed).pay_outs_disabled?
  end
end

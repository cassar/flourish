require 'test_helper'
require_relative 'concerns/currency_validator_test'

class MemberTest < ActiveSupport::TestCase
  include CurrencyValidatorTest

  test 'belongs to user association' do
    assert_equal users(:one), members(:one).user
  end

  test 'has many dividends association' do
    assert_includes members(:one).dividends, dividends(:one)
  end

  test 'dependent nullify relationship on dividends' do
    assert_equal members(:one), dividends(:one).member
    members(:one).destroy!

    assert_nil dividends(:one).reload.member
  end

  test 'has many contributions association' do
    assert_includes members(:one).contributions, contributions(:one)
  end

  test 'dependent nullify relationship on contributions' do
    assert_equal members(:one), contributions(:one).member
    members(:one).destroy!

    assert_nil contributions(:one).reload.member
  end

  test 'has many notification preferences association' do
    assert_includes members(:one).notification_preferences, notification_preferences(:contribution_received)
  end

  test 'dependent destroy relationship on notification preferences' do
    members(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      notification_preferences(:contribution_received).reload
    end
  end

  test 'accepts nested attributes for notification preferences' do
    assert_predicate notification_preferences(:contribution_received), :enabled

    members(:one).update!(notification_preferences_attributes: {
      '1' => { id: notification_preferences(:contribution_received).id, enabled: false }
    })

    assert_not_predicate notification_preferences(:contribution_received).reload, :enabled
  end

  test 'enforces unique paypalme_handle' do
    error = assert_raises ActiveRecord::RecordInvalid do
      members(:one).update! paypalme_handle: members(:has_paypalme_handle).paypalme_handle
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'ignores unique validation when paypalme_handle is nil' do
    members(:has_paypalme_handle).update! paypalme_handle: nil

    assert_nil members(:has_paypalme_handle).reload.paypalme_handle
  end

  test 'enforces case insensitive paypalme_handle' do
    upcase_duplicate_paypalid = members(:has_paypalme_handle).paypalme_handle.upcase

    assert_not_equal upcase_duplicate_paypalid, members(:has_paypalme_handle).paypalme_handle

    error = assert_raises ActiveRecord::RecordInvalid do
      members(:one).update! paypalme_handle: upcase_duplicate_paypalid
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'currency inclusion validation' do
    @currency_capable = members(:one)
    currency_inclusion_validation
  end

  test 'active scope' do
    assert_includes Member.active, members(:active)

    assert_not_includes Member.active, members(:admin)
    assert_not_includes Member.active, members(:inactive)
  end

  test 'inactive scope' do
    assert_includes Member.inactive, members(:inactive)

    assert_not_includes Member.inactive, members(:admin)
    assert_not_includes Member.inactive, members(:active)
  end

  test 'pay outs disabled when no paypal.me id' do
    assert_predicate members(:one), :pay_outs_disabled?
  end

  test 'pay outs enabled when paypal.me id present' do
    assert_not members(:has_paypalme_handle).pay_outs_disabled?
  end

  test 'create_notification_preferences! success' do
    assert_difference 'NotificationPreference.count', NotificationPreference.notification_names.count do
      members(:active).create_notification_preferences!
    end
  end

  test 'create_notification_preferences! error' do
    error = assert_raises ActiveRecord::RecordInvalid do
      members(:one).create_notification_preferences!
    end

    assert_match 'Notification name has already been taken', error.message
  end
end

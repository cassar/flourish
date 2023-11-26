require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'belongs to user association' do
    assert_equal users(:one), members(:active).user
  end

  test 'has many dividends association' do
    assert_includes members(:active).dividends, dividends(:one)
  end

  test 'dependend destroy relationship on dividends' do
    assert dividends(:one).present?
    members(:active).destroy

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end

  test 'new member defaults to inactive' do
    member = Member.create!(user: users(:no_member))

    assert member.inactive?
  end

  test 'active enum inactive state' do
    assert members(:inactive).inactive?
  end

  test 'active enum active state' do
    assert members(:active).active?
  end

  test 'member contribution cannot be less than 0' do
    assert members(:active).contribution_amount >= 0

    error = assert_raises ActiveRecord::RecordInvalid do
      members(:active).update! contribution_amount: -1
    end

    assert_equal 'Validation failed: Contribution amount must be greater than or equal to 0',
                 error.message
  end

  test 'contribution amount formatted' do
    assert_equal '$15.00', members(:active).contribution_amount_formatted
  end

  test 'should broadcast changes after save commit' do
    ActionCable::Server::Base.any_instance.stubs(:broadcast).once
    members(:active).update contribution_amount: 5
  end

  test 'should activate inactive membership with payid' do
    assert members(:inactive).inactive?

    members(:inactive).update! payid: 'something'
    assert members(:inactive).reload.active?
  end

  test 'should inactivate active membership without payid' do
    assert members(:active).active?

    members(:active).update! payid: ''
    assert members(:active).reload.inactive?
  end
end

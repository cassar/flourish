require 'test_helper'

class PoolMembershipTest < ActiveSupport::TestCase
  test 'belongs to pool association' do
    assert_equal pools(:general), pool_memberships(:general_contributor).pool
  end

  test 'belongs to member association' do
    assert_equal members(:admin), pool_memberships(:general_contributor).member
  end

  test 'role defaults to recipient' do
    membership = PoolMembership.new

    assert_predicate membership, :recipient?
  end

  test 'a member can only have one membership per pool' do
    duplicate = PoolMembership.new(
      pool: pools(:general),
      member: members(:one),
      role: :recipient
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:member_id], 'has already been taken'
  end

  test 'a pool can only have one contributor' do
    second_contributor = PoolMembership.new(
      pool: pools(:member_one_contributions),
      member: members(:two),
      role: :contributor
    )

    assert_not second_contributor.valid?
    assert_includes second_contributor.errors[:pool], 'already has a contributor'
  end

  test 'a second recipient does not trip the single-contributor validation' do
    second_recipient = PoolMembership.new(
      pool: pools(:member_one_contributions),
      member: members(:two),
      role: :recipient
    )

    assert_predicate second_recipient, :valid?
  end

  test 'a pool can have a contributor once its previous contributor is gone' do
    pool = Pool.create!(name: 'Reassignable Pool')
    first = PoolMembership.create!(pool:, member: members(:one), role: :contributor)
    first.destroy!

    second = PoolMembership.new(pool:, member: members(:two), role: :contributor)

    assert_predicate second, :valid?
  end
end

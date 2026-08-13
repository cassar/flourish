require 'test_helper'

class PodMembershipTest < ActiveSupport::TestCase
  test 'belongs to pod association' do
    assert_equal pods(:general), pod_memberships(:general_contributor).pod
  end

  test 'belongs to member association' do
    assert_equal members(:admin), pod_memberships(:general_contributor).member
  end

  test 'role defaults to recipient' do
    membership = PodMembership.new

    assert_predicate membership, :recipient?
  end

  test 'a member can only have one membership per pod' do
    duplicate = PodMembership.new(
      pod: pods(:general),
      member: members(:one),
      role: :recipient
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:member_id], 'has already been taken'
  end

  test 'a pod can only have one contributor' do
    second_contributor = PodMembership.new(
      pod: pods(:member_one_contributions),
      member: members(:two),
      role: :contributor
    )

    assert_not second_contributor.valid?
    assert_includes second_contributor.errors[:pod], 'already has a contributor'
  end

  test 'a second recipient does not trip the single-contributor validation' do
    second_recipient = PodMembership.new(
      pod: pods(:member_one_contributions),
      member: members(:two),
      role: :recipient
    )

    assert_predicate second_recipient, :valid?
  end

  test 'a pod can have a contributor once its previous contributor is gone' do
    pod = Pod.create!(name: 'Reassignable Pod')
    first = PodMembership.create!(pod:, member: members(:one), role: :contributor)
    first.destroy!

    second = PodMembership.new(pod:, member: members(:two), role: :contributor)

    assert_predicate second, :valid?
  end
end

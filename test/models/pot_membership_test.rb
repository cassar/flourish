require 'test_helper'

class PotMembershipTest < ActiveSupport::TestCase
  test 'belongs to pot association' do
    assert_equal pots(:general), pot_memberships(:general_contributor).pot
  end

  test 'belongs to member association' do
    assert_equal members(:admin), pot_memberships(:general_contributor).member
  end

  test 'role defaults to recipient' do
    membership = PotMembership.new

    assert_predicate membership, :recipient?
  end

  test 'a member can only have one membership per pot' do
    duplicate = PotMembership.new(
      pot: pots(:general),
      member: members(:one),
      role: :recipient
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:member_id], 'has already been taken'
  end

  test 'a pot can only have one contributor' do
    second_contributor = PotMembership.new(
      pot: pots(:member_one_contributions),
      member: members(:two),
      role: :contributor
    )

    assert_not second_contributor.valid?
    assert_includes second_contributor.errors[:pot], 'already has a contributor'
  end

  test 'a second recipient does not trip the single-contributor validation' do
    second_recipient = PotMembership.new(
      pot: pots(:member_one_contributions),
      member: members(:two),
      role: :recipient
    )

    assert_predicate second_recipient, :valid?
  end

  test 'a pot can have a contributor once its previous contributor is gone' do
    pot = Pot.create!(name: 'Reassignable Pot')
    first = PotMembership.create!(pot:, member: members(:one), role: :contributor)
    first.destroy!

    second = PotMembership.new(pot:, member: members(:two), role: :contributor)

    assert_predicate second, :valid?
  end
end

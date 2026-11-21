require 'test_helper'

class PotMembershipTest < ActiveSupport::TestCase
  test 'belongs to pot association' do
    assert_equal pots(:general), pot_memberships(:general_admin).pot
  end

  test 'belongs to member association' do
    assert_equal members(:admin), pot_memberships(:general_admin).member
  end

  test 'a member can only have one membership per pot' do
    duplicate = PotMembership.new(pot: pots(:general), member: members(:one))

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:member_id], 'has already been taken'
  end
end

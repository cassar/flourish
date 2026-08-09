require 'test_helper'

class PoolTest < ActiveSupport::TestCase
  test 'requires a name' do
    pool = Pool.new

    assert_not pool.valid?
    assert_includes pool.errors[:name], "can't be blank"
  end

  test 'has many pool memberships' do
    assert_includes pools(:general).pool_memberships, pool_memberships(:general_contributor)
  end

  test 'has many members through pool memberships' do
    assert_includes pools(:general).members, members(:admin)
  end

  test 'contributor_membership returns the contributor pool membership' do
    assert_equal pool_memberships(:general_contributor), pools(:general).contributor_membership
  end

  test 'contributor returns the contributor member' do
    assert_equal members(:admin), pools(:general).contributor
  end

  test 'contributor is nil when the pool has no contributor yet' do
    pool = Pool.create!(name: 'Empty Pool')

    assert_nil pool.contributor
  end

  test 'recipient_memberships returns only recipient pool memberships' do
    assert_includes pools(:general).recipient_memberships, pool_memberships(:general_recipient_one)
    assert_not_includes pools(:general).recipient_memberships, pool_memberships(:general_contributor)
  end

  test 'recipients returns only recipient members' do
    assert_includes pools(:general).recipients, members(:one)
    assert_not_includes pools(:general).recipients, members(:admin)
  end
end

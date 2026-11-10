require 'test_helper'

class PotTest < ActiveSupport::TestCase
  test 'is valid without a name' do
    assert_predicate Pot.new, :valid?
  end

  test 'has many pot memberships' do
    assert_includes pots(:general).pot_memberships, pot_memberships(:general_contributor)
  end

  test 'has many members through pot memberships' do
    assert_includes pots(:general).members, members(:admin)
  end

  test 'contributor_membership returns the contributor pot membership' do
    assert_equal pot_memberships(:general_contributor), pots(:general).contributor_membership
  end

  test 'contributor returns the contributor member' do
    assert_equal members(:admin), pots(:general).contributor
  end

  test 'contributor is nil when the pot has no contributor yet' do
    pot = Pot.create!(name: 'Empty Pot')

    assert_nil pot.contributor
  end

  test 'recipient_memberships returns only recipient pot memberships' do
    assert_includes pots(:general).recipient_memberships, pot_memberships(:general_recipient_one)
    assert_not_includes pots(:general).recipient_memberships, pot_memberships(:general_contributor)
  end

  test 'recipients returns only recipient members' do
    assert_includes pots(:general).recipients, members(:one)
    assert_not_includes pots(:general).recipients, members(:admin)
  end
end

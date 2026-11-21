require 'test_helper'

class PotTest < ActiveSupport::TestCase
  test 'is valid without a name' do
    assert_predicate Pot.new, :valid?
  end

  test 'has many pot memberships' do
    assert_includes pots(:general).pot_memberships, pot_memberships(:general_admin)
  end

  test 'has many members through pot memberships' do
    assert_includes pots(:general).members, members(:admin)
  end
end

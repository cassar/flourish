require 'test_helper'

class PodTest < ActiveSupport::TestCase
  test 'requires a name' do
    pod = Pod.new

    assert_not pod.valid?
    assert_includes pod.errors[:name], "can't be blank"
  end

  test 'has many pod memberships' do
    assert_includes pods(:general).pod_memberships, pod_memberships(:general_contributor)
  end

  test 'has many members through pod memberships' do
    assert_includes pods(:general).members, members(:admin)
  end

  test 'contributor_membership returns the contributor pod membership' do
    assert_equal pod_memberships(:general_contributor), pods(:general).contributor_membership
  end

  test 'contributor returns the contributor member' do
    assert_equal members(:admin), pods(:general).contributor
  end

  test 'contributor is nil when the pod has no contributor yet' do
    pod = Pod.create!(name: 'Empty Pod')

    assert_nil pod.contributor
  end

  test 'recipient_memberships returns only recipient pod memberships' do
    assert_includes pods(:general).recipient_memberships, pod_memberships(:general_recipient_one)
    assert_not_includes pods(:general).recipient_memberships, pod_memberships(:general_contributor)
  end

  test 'recipients returns only recipient members' do
    assert_includes pods(:general).recipients, members(:one)
    assert_not_includes pods(:general).recipients, members(:admin)
  end
end

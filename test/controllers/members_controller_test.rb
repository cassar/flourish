require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'requires sign in' do
    sign_out :user

    get pot_member_path(pots(:general), members(:two))

    assert_redirected_to new_user_session_path
  end

  test 'pot page bubbles link to the member' do
    get pot_path(pots(:general))

    assert_select 'a[data-person][href=?]', pot_member_path(pots(:general), members(:two)),
                  text: "Member #{members(:two).id}"
  end

  test 'shows the member with their dividends in this pot' do
    get pot_member_path(pots(:general), members(:one))

    assert_response :success
    assert_select 'h1', "Member #{members(:one).id}"

    dividends = css_select('[data-dividend]').map { |el| el.text.squish }

    assert_equal 3, dividends.size
    date = dividends(:one).created_at.strftime('%a, %-d %b %Y')

    assert_includes dividends, "Distribution #1 Pending #{date} $5.00 AUD"
    assert_select 'a[data-dividend][href=?]', pot_distribution_path(pots(:general), distributions(:one))
  end

  test 'shows only contributions made to this pot' do
    get pot_member_path(pots(:member_one_contributions), members(:one))

    assert_select '[data-contribution]', count: 1
    assert_select '[data-dividend]', count: 0
    assert_select 'p', text: 'No dividends yet.'

    get pot_member_path(pots(:general), members(:one))

    assert_select '[data-contribution]', count: 0
    assert_select 'p', text: 'No contributions yet.'
  end

  test 'shows a contribution that has no distribution yet' do
    Contribution.create!(member: members(:one), pot: pots(:general), amount_in_base_units: 500,
                         transaction_identifier: 'awaiting_distribution')

    get pot_member_path(pots(:general), members(:one))

    assert_select 'div[data-contribution]', text: /Awaiting distribution/
    assert_select 'a[data-contribution]', count: 0
  end

  test "can't see members of pots I'm not in" do
    get pot_member_path(pots(:member_two_contributions), members(:two))

    assert_response :not_found
  end

  test "can't see someone who isn't in the pot" do
    get pot_member_path(pots(:member_one_contributions), members(:two))

    assert_response :not_found
  end
end

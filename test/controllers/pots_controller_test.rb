require 'test_helper'

class PotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'requires sign in' do
    sign_out :user

    get pots_path

    assert_redirected_to new_user_session_path
  end

  test 'signing in lands on the pots index' do
    sign_out :user
    users(:one).update!(password: 'password')

    post user_session_path, params: { user: { email: users(:one).email, password: 'password' } }

    assert_redirected_to pots_path
  end

  test 'index shows a card for each of my pots with its people count' do
    get pots_path

    assert_response :success
    assert_select 'article.card', count: 2
    assert_select 'article.card', text: /Pot #{pots(:general).id}\s+4 people/
    assert_select 'article.card', text: /Pot #{pots(:member_one_contributions).id}\s+2 people/
    assert_select 'article.card', text: /Pot #{pots(:member_two_contributions).id}\b/, count: 0
  end

  test 'index cards link to each pot' do
    get pots_path

    assert_select 'article.card a[href=?]', pot_path(pots(:general))
  end

  test 'show lists the people in the pot' do
    members(:admin).update!(name: 'Luke')

    get pot_path(pots(:general))

    assert_response :success
    assert_select 'h1', "Pot #{pots(:general).id}"
    assert_select 'section p', '4 people'
    people = css_select('[data-person]').map { |li| li.text.squish }

    assert_equal 4, people.size
    assert_includes people, 'Luke'
    assert_includes people, "Member #{members(:one).id}"
    assert_includes people, "Member #{members(:two).id}"
  end

  test 'show lists distribution totals, newest first' do
    get pot_path(pots(:general))

    totals = css_select('[data-distribution]').map { |tile| tile.text.squish }

    assert_equal ['$0.00 AUD', '$1,234.56 AUD'], totals
  end

  test 'show has an empty state for distributions' do
    get pot_path(pots(:member_one_contributions))

    assert_select 'p', text: 'No distributions yet.'
  end

  test "can't see pots I'm not in" do
    get pot_path(pots(:member_two_contributions))

    assert_response :not_found
  end

  test 'index shows an empty state' do
    members(:one).pot_memberships.destroy_all

    get pots_path

    assert_select 'p', text: 'No pots yet.'
  end

  test 'create makes a pot with me in it' do
    assert_difference 'Pot.count', 1 do
      post pots_path
    end

    assert_redirected_to pots_path
    assert_equal [members(:one)], Pot.last.members
  end

  test 'show offers to leave the pot' do
    get pot_path(pots(:general))

    assert_select 'form[action=?][data-turbo-confirm][data-confirm-button=Leave]', pot_membership_path(pots(:general))
    assert_select 'dialog#confirm-dialog'
  end
end

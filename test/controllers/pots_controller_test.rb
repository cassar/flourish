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

  test 'index only offers delete on pots I contribute to' do
    get pots_path

    assert_select 'form[action=?][data-turbo-confirm][data-confirm-button=Delete]',
                  pot_path(pots(:member_one_contributions))
    assert_select 'dialog#confirm-dialog'
    assert_select 'form[action=?]', pot_path(pots(:general)), count: 0
  end

  test 'index cards link to each pot' do
    get pots_path

    assert_select 'article.card a[href=?]', pot_path(pots(:general))
  end

  test 'show lists the people in the pot, contributor first' do
    members(:admin).update!(name: 'Luke')

    get pot_path(pots(:general))

    assert_response :success
    assert_select 'h1', "Pot #{pots(:general).id}"
    assert_select 'section p', '4 people'
    people = css_select('[data-person]').map { |li| li.text.squish }

    assert_equal 'Luke Contributor', people.first
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

  test 'create makes a pot with me as the contributor' do
    assert_difference 'Pot.count', 1 do
      post pots_path
    end

    assert_redirected_to pots_path
    assert_equal members(:one), Pot.last.contributor
  end

  test 'destroy an empty pot' do
    post pots_path
    pot = Pot.last

    assert_difference 'Pot.count', -1 do
      delete pot_path(pot)
    end

    assert_redirected_to pots_path
  end

  test "can't delete pots I'm only a recipient of" do
    assert_no_difference 'Pot.count' do
      delete pot_path(pots(:general))
    end

    assert_response :not_found
  end

  test "won't delete a pot with contributions or distributions" do
    assert_no_difference 'Pot.count' do
      delete pot_path(pots(:member_one_contributions))
    end

    assert_redirected_to pots_path
    assert_match "Pot #{pots(:member_one_contributions).id} has contributions", flash[:alert]
  end
end

require 'test_helper'

class ContributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'requires sign in' do
    sign_out :user

    get new_pot_contribution_path(pots(:general))

    assert_redirected_to new_user_session_path
  end

  test 'new explains what contributing does' do
    get new_pot_contribution_path(pots(:general))

    assert_response :success
    assert_select 'h1', "Contribute to Pot #{pots(:general).id}"
    assert_select 'input[name=?]', 'contribution[amount]'
    assert_select 'ol li', text: /new distribution is created/
    assert_select 'ol li', text: /Everyone in the pot is notified/
    assert_select 'ol li', text: /closes after a day.*3 other members/m
  end

  test 'create makes the next distribution, paid out by my contribution' do
    pot = pots(:general)

    assert_difference -> { pot.distributions.count } => 1, -> { pot.contributions.count } => 1 do
      post pot_contributions_path(pot), params: { contribution: { amount: '$1,234.50' } }
    end

    distribution = pot.distributions.find_by!(number: 3)
    contribution = distribution.contribution

    assert_equal 123_450, distribution.amount_in_base_units
    assert_equal 123_450, contribution.amount_in_base_units
    assert_equal 'AUD', contribution.currency
    assert_equal members(:one), contribution.member
    assert_equal pot, contribution.pot
    assert_redirected_to pot_distribution_path(pot, distribution)
    assert_equal 'Thanks! Distribution #3 has been created.', flash[:notice]
  end

  test 'contributions need no transaction identifier' do
    post pot_contributions_path(pots(:general)), params: { contribution: { amount: '10' } }
    post pot_contributions_path(pots(:general)), params: { contribution: { amount: '20' } }

    assert_equal [1_000, 2_000],
                 pots(:general).distributions.where(number: [3, 4]).order(:number).pluck(:amount_in_base_units)
  end

  test 'create rejects amounts that are not positive dollars' do
    ['', '0', '-5', 'abc', '1.234', '10000000'].each do |amount|
      assert_no_difference -> { Distribution.count } do
        post pot_contributions_path(pots(:general)), params: { contribution: { amount: } }
      end

      assert_response :unprocessable_content
      assert_select 'p.text-error', /Enter an amount in dollars/
    end
  end

  test "can't contribute to a pot I'm not in" do
    post pot_contributions_path(pots(:member_two_contributions)), params: { contribution: { amount: '10' } }

    assert_response :not_found
  end
end

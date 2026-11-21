require 'test_helper'

class PotMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'requires sign in' do
    sign_out :user

    delete pot_membership_path(pots(:general))

    assert_redirected_to new_user_session_path
  end

  test 'leaving a pot removes me but keeps the pot and its history' do
    assert_difference 'PotMembership.count', -1 do
      assert_no_difference %w[Pot.count Distribution.count Contribution.count] do
        delete pot_membership_path(pots(:general))
      end
    end

    assert_redirected_to pots_path
    assert_equal "You left Pot #{pots(:general).id}.", flash[:notice]
    assert_not_includes pots(:general).members, members(:one)
  end

  test "can't leave a pot I'm not in" do
    assert_no_difference 'PotMembership.count' do
      delete pot_membership_path(pots(:member_two_contributions))
    end

    assert_response :not_found
  end
end

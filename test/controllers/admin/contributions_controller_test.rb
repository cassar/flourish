require 'test_helper'

module Admin
  class ContributionsControllerTest < ActionDispatch::IntegrationTest
    test 'not authenticated for new' do
      get new_admin_member_contribution_path(members(:one))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for new' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get new_admin_member_contribution_path(members(:one))

      assert_redirected_to root_path
    end

    test 'get new' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      get new_admin_member_contribution_path(members(:one))

      assert_response :success
    end

    test 'not authenticated for preview' do
      get preview_admin_member_contributions_path(members(:one))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for preview' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get preview_admin_member_contributions_path(members(:one)),
          params: { contribution: { transaction_identifier: 'xxxx' } }

      assert_redirected_to root_path
      assert_equal "You don't have access.", flash[:alert]
    end

    test 'get preview' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      get preview_admin_member_contributions_path(members(:one)),
          params: { contribution: {
            transaction_identifier: 'xxxx',
            amount_in_base_units: 5000
          } }

      assert_response :success
    end

    test 'not authenticated for create' do
      post admin_member_contributions_path(members(:one))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for create' do
      assert_not users(:one).admin?
      sign_in users(:one)

      assert_no_difference 'Contribution.count' do
        post admin_member_contributions_path(members(:one)),
             params: { contribution: { transaction_identifier: 'xxxx' } }
      end

      assert_redirected_to root_path
      assert_equal "You don't have access.", flash[:alert]
    end

    test 'creates a new record on post create on valid record' do
      sign_in users(:admin)

      assert_difference 'Contribution.count' do
        post admin_member_contributions_path(members(:one)), params: { contribution: {
          currency: 'USD',
          amount_in_base_units: 4000,
          fees_in_base_units: 50,
          transaction_identifier: 'xxxx'
        } }
      end

      assert_redirected_to active_admin_members_path
      assert_equal 'New contribution created and notification sent', flash[:success]
      assert_equal 'USD', Contribution.last.currency
      assert_equal 4000, Contribution.last.amount_in_base_units
      assert_equal 50, Contribution.last.fees_in_base_units
      assert_equal 'xxxx', Contribution.last.transaction_identifier
      assert_equal members(:one), Contribution.last.member
    end

    test 'sends notification for preference enabled' do
      ActionMailer::Base.deliveries.clear
      sign_in users(:admin)
      notification_preference = notification_preferences(:contribution_received)
      member = members(:one)

      assert_equal member, notification_preference.member
      assert_predicate notification_preference, :enabled

      perform_enqueued_jobs do
        post admin_member_contributions_path(member), params: { contribution: {
          currency: 'USD',
          amount_in_base_units: 4000,
          fees_in_base_units: 50,
          transaction_identifier: 'xxxx'
        } }
      end

      assert_equal 1, ActionMailer::Base.deliveries.count
      assert(ActionMailer::Base.deliveries.all? do |mail|
        mail.subject.match?(/Your Contribution has been Received/)
      end)
    end

    test 'does not send a notification for preference disabled' do
      ActionMailer::Base.deliveries.clear
      sign_in users(:admin)
      notification_preference = notification_preferences(:contribution_received_disabled)
      member = members(:two)

      assert_equal member, notification_preference.member
      assert_not_predicate notification_preference, :enabled

      perform_enqueued_jobs do
        post admin_member_contributions_path(member), params: { contribution: {
          currency: 'USD',
          amount_in_base_units: 4000,
          fees_in_base_units: 50,
          transaction_identifier: 'xxxx'
        } }
      end

      assert_equal 0, ActionMailer::Base.deliveries.count
    end

    test 'post create on invalid record' do
      sign_in users(:admin)

      assert_no_difference 'Contribution.count' do
        post admin_member_contributions_path(members(:one)), params: { contribution: {
          transaction_identifier: 'xxxx'
        } }
      end

      assert_response :success
      assert_equal 'Amount in base units is not a number', flash[:alert]
    end
  end
end

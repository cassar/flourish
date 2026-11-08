require 'test_helper'

class DistributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'requires sign in' do
    sign_out :user

    get pod_distribution_path(pods(:general), distributions(:one))

    assert_redirected_to new_user_session_path
  end

  test 'is addressed by its number within the pod' do
    path = pod_distribution_path(pods(:general), distributions(:one))

    assert_equal "/pods/#{pods(:general).id}/distributions/1", path
  end

  test 'shows the total, date and who was paid' do
    get pod_distribution_path(pods(:general), distributions(:one))

    assert_response :success
    assert_select 'h1', 'Distribution #1'
    assert_select 'p', text: '$1,234.56'
    assert_select 'p', text: distributions(:one).date_formatted

    recipients = css_select('[data-recipient]').map { |el| el.text.squish }

    assert_equal 4, recipients.size
    assert_includes recipients, "Member #{members(:two).id} Pending $5.00 HKD"
    assert_includes recipients, "Member #{members(:one).id} $1.00 AUD"
  end

  test 'shows a dividend whose member has since been removed' do
    members(:two).destroy # nullifies dividends(:pending_payout_two).member_id, as in production

    get pod_distribution_path(pods(:general), distributions(:one))

    assert_response :success

    recipients = css_select('[data-recipient]').map { |el| el.text.squish }

    assert_includes recipients, 'Former member Pending $5.00 HKD'
  end

  test 'shows an empty state when no one was paid' do
    get pod_distribution_path(pods(:general), distributions(:two))

    assert_select 'p', text: 'No one was paid from this distribution.'
  end

  test "can't see distributions of pods I'm not in" do
    members(:one).pod_memberships.where(pod: pods(:general)).destroy_all

    get pod_distribution_path(pods(:general), distributions(:one))

    assert_response :not_found
  end

  test 'unknown distribution number is not found' do
    get pod_distribution_path(pods(:general), 999)

    assert_response :not_found
  end

  test 'pod page tiles link to the distribution' do
    get pod_path(pods(:general))

    assert_select 'a[data-distribution][href=?]', pod_distribution_path(pods(:general), distributions(:one))
  end
end

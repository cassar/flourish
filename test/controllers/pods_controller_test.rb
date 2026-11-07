require 'test_helper'

class PodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'requires sign in' do
    sign_out :user

    get pods_path

    assert_redirected_to new_user_session_path
  end

  test 'signing in lands on the pods index' do
    sign_out :user
    users(:one).update!(password: 'password')

    post user_session_path, params: { user: { email: users(:one).email, password: 'password' } }

    assert_redirected_to pods_path
  end

  test 'index shows a card for each of my pods with its people count' do
    get pods_path

    assert_response :success
    assert_select 'article.card', count: 2
    assert_select 'article.card', text: /Pod #{pods(:general).id}\s+4 people/
    assert_select 'article.card', text: /Pod #{pods(:member_one_contributions).id}\s+2 people/
    assert_select 'article.card', text: /Pod #{pods(:member_two_contributions).id}\b/, count: 0
  end

  test 'index only offers delete on pods I contribute to' do
    get pods_path

    assert_select 'form[action=?]', pod_path(pods(:member_one_contributions))
    assert_select 'form[action=?]', pod_path(pods(:general)), count: 0
  end

  test 'index shows an empty state' do
    members(:one).pod_memberships.destroy_all

    get pods_path

    assert_select 'p', text: 'No pods yet.'
  end

  test 'create makes a pod with me as the contributor' do
    assert_difference 'Pod.count', 1 do
      post pods_path
    end

    assert_redirected_to pods_path
    assert_equal members(:one), Pod.last.contributor
  end

  test 'destroy an empty pod' do
    post pods_path
    pod = Pod.last

    assert_difference 'Pod.count', -1 do
      delete pod_path(pod)
    end

    assert_redirected_to pods_path
  end

  test "can't delete pods I'm only a recipient of" do
    assert_no_difference 'Pod.count' do
      delete pod_path(pods(:general))
    end

    assert_response :not_found
  end

  test "won't delete a pod with contributions or distributions" do
    assert_no_difference 'Pod.count' do
      delete pod_path(pods(:member_one_contributions))
    end

    assert_redirected_to pods_path
    assert_match "Pod #{pods(:member_one_contributions).id} has contributions", flash[:alert]
  end
end

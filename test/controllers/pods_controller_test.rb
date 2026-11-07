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

  test 'index lists only my pods with their people count' do
    get pods_path

    assert_response :success
    assert_select 'li', count: 2
    assert_select 'li', text: /General Pod\s+4 people/
    assert_select 'li', text: /Member One Contributions\s+2 people/
    assert_select 'li', text: /Member Two Contributions/, count: 0
  end

  test 'index shows an empty state' do
    members(:one).pod_memberships.destroy_all

    get pods_path

    assert_select 'p', text: 'No pods yet.'
  end

  test 'new' do
    get new_pod_path

    assert_response :success
  end

  test 'create adds me to the pod' do
    assert_difference 'Pod.count', 1 do
      post pods_path, params: { pod: { name: 'Climbing' } }
    end

    assert_redirected_to pods_path
    assert_includes Pod.find_by!(name: 'Climbing').members, members(:one)
  end

  test 'create with a blank name re-renders the form' do
    assert_no_difference 'Pod.count' do
      post pods_path, params: { pod: { name: '' } }
    end

    assert_response :unprocessable_content
  end

  test 'edit' do
    get edit_pod_path(pods(:general))

    assert_response :success
  end

  test 'update' do
    patch pod_path(pods(:general)), params: { pod: { name: 'Everyone' } }

    assert_redirected_to pods_path
    assert_equal 'Everyone', pods(:general).reload.name
  end

  test 'update with a blank name re-renders the form' do
    patch pod_path(pods(:general)), params: { pod: { name: '' } }

    assert_response :unprocessable_content
    assert_equal 'General Pod', pods(:general).reload.name
  end

  test "can't touch pods I'm not in" do
    patch pod_path(pods(:member_two_contributions)), params: { pod: { name: 'Mine now' } }

    assert_response :not_found
  end

  test 'destroy an empty pod' do
    post pods_path, params: { pod: { name: 'Temporary' } }
    pod = Pod.find_by!(name: 'Temporary')

    assert_difference 'Pod.count', -1 do
      delete pod_path(pod)
    end

    assert_redirected_to pods_path
  end

  test "won't destroy a pod with contributions or distributions" do
    assert_no_difference 'Pod.count' do
      delete pod_path(pods(:general))
    end

    assert_redirected_to pods_path
    assert_match "can't be deleted", flash[:alert]
  end
end

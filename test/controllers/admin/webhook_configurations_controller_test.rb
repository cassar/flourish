require 'test_helper'

module Admin
  class WebhookConfigurationsControllerTest < ActionDispatch::IntegrationTest
    test 'not authenticated for show' do
      get admin_webhook_configuration_path

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for show' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get admin_webhook_configuration_path

      assert_redirected_to root_path
    end

    test 'get show' do
      sign_in users(:admin)

      get admin_webhook_configuration_path

      assert_response :success
    end

    test 'not authenticated for update' do
      patch admin_webhook_configuration_path

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for update' do
      sign_in users(:one)

      patch admin_webhook_configuration_path, params: { webhook_configuration: { url: 'https://example.com' } }

      assert_redirected_to root_path
    end

    test 'updates webhook url' do
      sign_in users(:admin)

      patch admin_webhook_configuration_path,
            params: { webhook_configuration: { url: 'https://example.com/webhooks/token' } }

      assert_redirected_to admin_webhook_configuration_path
      assert_equal I18n.t('controllers.admin.webhook_configurations.update.success'), flash[:success]
      assert_equal 'https://example.com/webhooks/token', WebhookConfiguration.instance.url
    end

    test 'clears webhook url' do
      WebhookConfiguration.instance.update!(url: 'https://example.com/webhooks/token')
      sign_in users(:admin)

      patch admin_webhook_configuration_path, params: { webhook_configuration: { url: '' } }

      assert_redirected_to admin_webhook_configuration_path
      assert_predicate WebhookConfiguration.instance.url, :blank?
    end

    test 'shows error for invalid url' do
      sign_in users(:admin)

      patch admin_webhook_configuration_path, params: { webhook_configuration: { url: 'not-a-url' } }

      assert_response :success
      assert_includes flash[:alert], 'must be a valid URL'
    end
  end
end

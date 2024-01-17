require 'test_helper'

module UpBank
  class CreateWebhookTest < ActiveSupport::TestCase
    test 'call with valid credentials and successful response' do
      Rails.cache.stubs(:write).with(UpBank::WEBHOOK_SECRET_KEY_CACHE_KEY, 'secret key').returns(true).once

      stub_request(:post, 'https://api.up.com.au/api/v1/webhooks')
        .with(
          body: {
            data: {
              attributes: {
                url: 'https://test.flourish.buzz/admin/up_bank',
                description: 'webhook for test.flourish.buzz'
              }
            }
          },
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Content-Type' => 'application/json',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(
          status: 200,
          body: { data: { attributes: { secretKey: 'secret key' } } }.to_json,
          headers: {}
        )

      assert UpBank::CreateWebhook.new.call
    end
  end
end

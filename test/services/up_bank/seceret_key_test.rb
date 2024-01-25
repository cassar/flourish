require 'test_helper'

module UpBank
  class SeceretKeyTest < ActiveSupport::TestCase
    test 'with cached value' do
      Rails.cache.stubs(:fetch).with(UpBank::WEBHOOK_SECRET_KEY_CACHE_KEY).returns('cached secret key').once

      assert_equal 'cached secret key', UpBank::SecretKey.new.call
    end

    test 'with successful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/webhooks?page%5Bsize%5D=1')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(
          status: 200,
          body: { data: successful_payload }.to_json,
          headers: {}
        )

      assert_equal 'correct key', UpBank::SecretKey.new.call
    end

    def successful_payload
      [
        { attributes: {
          url: 'test.webhook.url',
          secretKey: 'not the correct key'
        } },
        { attributes: {
          url: UpBank::WEBHOOK_URL,
          secretKey: 'correct key'
        } }
      ]
    end
  end
end

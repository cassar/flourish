require 'test_helper'

module UpBank
  class WebhooksTest < ActiveSupport::TestCase
    test 'with successful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/webhooks?page%5Bsize%5D=1')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(status: 200, body: '{"data": []}', headers: {})

      assert_equal [], UpBank::Webhooks.new.call
    end

    test 'with unsuccessful response' do
      stub_request(:get, 'https://api.up.com.au/api/v1/webhooks?page%5Bsize%5D=1')
        .with(
          headers: {
            'Authorization' => 'Bearer valid_access_token',
            'Host' => 'api.up.com.au:443'
          }
        )
        .to_return(status: 400, body: '', headers: {})

      assert_raises(UpBank::Webhooks::Error) do
        UpBank::Webhooks.new.call
      end
    end
  end
end

require 'test_helper'

class UpBankTest < ActionDispatch::IntegrationTest
  test 'webhooks url correct' do
    assert_equal UpBank::WEBHOOK_URL, admin_up_bank_url(host: UpBank::DOMAIN, protocol: 'https')
  end
end

module UpBank
  ACCESS_TOKEN = ENV.fetch('UP_BANK_ACCESS_TOKEN', 'valid_access_token')
  ACCOUNT_NUMBER = ENV.fetch('UP_BANK_ACCOUNT_NUMBER', 'valid_account_number')
  DOMAIN = ENV.fetch('DOMAIN', 'test.flourish.buzz')
  WEBHOOK_URL = "https://#{DOMAIN}/admin/up_bank".freeze
  WEBHOOK_SECRET_KEY_CACHE_KEY = 'up_bank_webhook_secret_key'.freeze
end

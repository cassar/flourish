Hcaptcha.configure do |config|
  config.secret_key = Rails.application.credentials.dig(:hcaptcha, :secret_key) || 'placeholder'
  config.site_key   = Rails.application.credentials.dig(:hcaptcha, :site_key) || 'placeholder'
end

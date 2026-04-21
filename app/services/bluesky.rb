module Bluesky
  BASE_URI = 'https://bsky.social/xrpc'.freeze
  HANDLE = (Rails.application.credentials.dig(:bluesky, :handle) || 'test_bluesky_handle').freeze
  APP_PASSWORD = (Rails.application.credentials.dig(:bluesky, :app_password) || 'test_bluesky_app_password').freeze
end

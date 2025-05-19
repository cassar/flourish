module Bluesky
  BASE_URI = 'https://bsky.social/xrpc'.freeze
  HANDLE = ENV.fetch('BLUESKY_HANDLE', 'test_bluesky_handle').freeze
  APP_PASSWORD = ENV.fetch('BLUESKY_APP_PASSWORD', 'test_bluesky_app_password').freeze
end

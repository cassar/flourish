require 'test_helper'
require 'capybara/selenium/driver'
require 'capybara/selenium/driver_specializations/chrome_driver'

module ChromeStorageClearOriginFix
  def execute_cdp(cmd, **params)
    if cmd == 'Storage.clearDataForOrigin' && params[:origin] == '*'
      params[:origin] = Capybara.current_session.server.base_url
    end
    super
  end
end
Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeStorageClearOriginFix)
WebMock.disable_net_connect!(allow_localhost: true)

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers

  Capybara.register_driver :headless_chrome_ci do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1400,1400')
    options.add_argument('--no-sandbox') if ENV['CI']
    options.add_argument('--disable-dev-shm-usage') if ENV['CI']
    options.binary = ENV['CHROME_BIN'] if ENV['CHROME_BIN']
    if File.exist?('/usr/bin/chromedriver')
      service = Selenium::WebDriver::Chrome::Service.new(path: '/usr/bin/chromedriver')
    end
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, service: service)
  end

  driven_by :headless_chrome_ci

  def sign_in_as(user)
    sign_in user
  end
end

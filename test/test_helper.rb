require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch
  merge_timeout 3600
  minimum_coverage line: 100, branch: 100

  add_group 'Models',      'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Services',    'app/services'
  add_group 'Jobs',        'app/jobs'
  add_group 'Helpers',     'app/helpers'

  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/channels/application_cable/channel.rb'
  add_filter 'app/channels/application_cable/connection.rb'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end

    parallelize_teardown do
      SimpleCov.result
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers

    def stub_eu_central_bank_request
      stub_request(:get, 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: File.read('test/fixtures/files/eurofxref-daily.xml'), headers: {})
    end
  end
end

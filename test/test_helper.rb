ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers

    # Configure Money gem to use the exchange rates file
    bank = Money::Bank::VariableExchange.new
    rates_file = Rails.root.join('test/fixtures/files/exchange_rates.json')

    # Load exchange rates
    bank.import_rates(:json, rates_file)
    Money.default_bank = bank
  end
end

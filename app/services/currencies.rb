module Currencies
  PAYPAL_SUPPORTED = YAML.load_file('app/services/paypal_supported_currencies.yml')
  EU_CENTRAL_BANK_UNSUPPORTED = ['TWD'].freeze
  SUPPORTED = PAYPAL_SUPPORTED - EU_CENTRAL_BANK_UNSUPPORTED
  DEFAULT = 'AUD'.freeze
end

module Currencies
  SUPPORTED_CURRENCIES = YAML.load_file('app/services/paypal_supported_currencies.yml')
end

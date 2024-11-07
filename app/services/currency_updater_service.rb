class CurrencyUpdaterService
  CACHE_FILE_PATH = 'tmp/exchange_rates.xml'.freeze

  def call
    Money.default_bank.save_rates CACHE_FILE_PATH
    Money.default_bank.update_rates CACHE_FILE_PATH
  end
end

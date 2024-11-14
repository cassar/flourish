module CurrencyValidator
  extend ActiveSupport::Concern

  included do
    validates :currency, inclusion: {
      in: Currencies::SUPPORTED_CURRENCIES,
      message: :unsupported_currency
    }
  end
end

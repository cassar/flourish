module CurrencyValidator
  extend ActiveSupport::Concern

  included do
    validates :currency, inclusion: {
      in: Currencies::SUPPORTED,
      message: :unsupported_currency
    }
  end
end

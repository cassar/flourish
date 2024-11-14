class PayOut < ApplicationRecord
  belongs_to :dividend

  validates :transaction_identifier, uniqueness: true

  include CurrencyValidator
end

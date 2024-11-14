class PayOut < ApplicationRecord
  belongs_to :dividend

  include CurrencyValidator
end

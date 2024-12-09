class Distribution < ApplicationRecord
  has_many :amounts, dependent: :destroy
  has_many :dividends, through: :amounts

  validates :name, uniqueness: true, presence: true

  def default_amount
    amounts.find_by currency: Currencies::DEFAULT
  end

  def settled?
    dividends.issued.none?
  end
end

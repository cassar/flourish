class Distribution < ApplicationRecord
  has_many :amounts, dependent: :destroy
  has_many :dividends, through: :amounts
  has_many :contributions, dependent: :nullify

  validates :number, uniqueness: true, presence: true

  def default_amount
    amounts.find_by currency: Currencies::DEFAULT
  end

  def settled?
    dividends.issued.none?
  end

  def name
    "##{number || 0}"
  end

  def to_param
    number.to_s
  end
end

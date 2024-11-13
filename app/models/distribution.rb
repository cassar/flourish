class Distribution < ApplicationRecord
  has_many :amounts, dependent: :destroy
  has_many :dividends, through: :amounts

  validates :name, uniqueness: true, presence: true
end

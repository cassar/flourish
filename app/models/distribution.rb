class Distribution < ApplicationRecord
  has_many :amounts, dependent: :destroy
  has_many :dividends, through: :amounts
  has_many :contributions, dependent: :nullify
  has_many :expenses, dependent: :nullify

  validates :number, uniqueness: true, presence: true

  after_create_commit :log_activity

  def default_amount
    amounts.find_by currency: Currencies::DEFAULT
  end

  def date_formatted
    created_at.strftime('%a, %d %b %Y')
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

  private

  def log_activity
    ActivityLog.create(message: "Distribution #{name} created")
  end
end

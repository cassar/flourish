class Distribution < ApplicationRecord
  belongs_to :pot

  has_many :amounts, dependent: :destroy
  has_many :dividends, through: :amounts
  has_many :contributions, dependent: :nullify
  has_many :expenses, dependent: :nullify

  validates :number, uniqueness: { scope: :pot_id }, presence: true

  after_create_commit :log_activity

  # Total paid out, in AUD.
  def amount
    Money.new(amount_in_base_units, 'AUD')
  end

  def date_formatted
    created_at.to_datetime.strftime('%a, %d %b %Y')
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

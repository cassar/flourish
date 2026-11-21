class Distribution < ApplicationRecord
  belongs_to :pot

  has_many :amounts, dependent: :destroy
  has_many :dividends, through: :amounts
  # The one contribution this distribution pays out.
  has_one :contribution, dependent: :nullify
  has_many :expenses, dependent: :nullify

  validates :number, uniqueness: { scope: :pot_id }, presence: true

  after_create_commit :log_activity

  # Total paid out, in AUD.
  def amount
    Money.new(amount_in_base_units, 'AUD')
  end

  def amount_formatted_without_currency
    amount.format(with_currency: false)
  end

  # The member whose contribution this distribution pays out.
  def contributor_id
    contribution&.member_id
  end

  # Everyone in the pot who can receive a dividend from this distribution.
  def recipients
    pot.members.where.not(id: contributor_id)
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

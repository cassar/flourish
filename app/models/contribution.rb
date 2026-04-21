class Contribution < ApplicationRecord
  belongs_to :member
  belongs_to :distribution, optional: true

  validates :amount_in_base_units, numericality: { only_integer: true, greater_than: 0 }
  validates :fees_in_base_units, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :transaction_identifier, uniqueness: true

  include CurrencyValidator

  before_create { self.uuid ||= SecureRandom.uuid }
  after_create_commit :log_activity

  def amount_formatted
    Money.new(amount_in_base_units, currency).format
  end

  def fees_formatted
    Money.new(fees_in_base_units, currency).format
  end

  def gross_amount_formatted
    Money.new(gross_amount_in_base_units, currency).format
  end

  def created_at_formatted
    created_at.strftime("%a, #{created_at.day.ordinalize} %b %Y")
  end

  private

  def log_activity
    ActivityLog.create(message: "Contribution of #{amount_formatted} received from #{member.user.email}")
  end

  def gross_amount_in_base_units
    amount_in_base_units + fees_in_base_units
  end
end

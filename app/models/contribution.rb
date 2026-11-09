class Contribution < ApplicationRecord
  belongs_to :member
  belongs_to :distribution, optional: true
  belongs_to :pod

  include MonetaryTransaction

  before_create { self.uuid ||= SecureRandom.uuid }
  after_create_commit :log_activity

  def gross_amount_formatted
    Money.new(gross_amount_in_base_units, currency).format
  end

  def created_at_formatted
    date = created_at.to_datetime
    date.strftime("%a, #{date.day.ordinalize} %b %Y")
  end

  private

  def log_activity
    ActivityLog.create(message: "Contribution of #{amount_formatted} received")
  end

  def gross_amount_in_base_units
    amount_in_base_units + fees_in_base_units
  end
end

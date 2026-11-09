class PayOut < ApplicationRecord
  belongs_to :dividend

  include MonetaryTransaction

  after_create_commit :log_activity

  private

  def log_activity
    ActivityLog.create(message: "Payout of #{amount_formatted} completed")
  end
end

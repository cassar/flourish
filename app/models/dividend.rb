class Dividend < ApplicationRecord
  enum :status, {
    pending_payout: 1,
    paid_out: 2
  }

  belongs_to :member
  belongs_to :amount

  has_one :distribution, through: :amount
  has_one :pay_out, dependent: :destroy

  validate :not_to_the_contributor, if: -> { member_id_changed? || amount_id_changed? }

  after_update_commit :log_status_change, if: :saved_change_to_status?

  private

  def not_to_the_contributor
    return if member_id.nil? || member_id != amount&.distribution&.contributor_id

    errors.add(:member, :is_distribution_contributor)
  end

  def log_status_change
    ActivityLog.create(message: "Payout requested by #{member.user.email}") if pending_payout?
  end
end

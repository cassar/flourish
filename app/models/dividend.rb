class Dividend < ApplicationRecord
  enum :status, {
    issued: 0,
    pending_pay_out: 1,
    pay_out_complete: 2,
    manually_recontributed: 3,
    auto_recontributed: 4
  }

  belongs_to :member
  belongs_to :amount

  has_one :distribution, through: :amount
  has_one :pay_out, dependent: :destroy

  after_update_commit :log_status_change, if: :saved_change_to_status?

  scope :owed, -> { where(status: %i[pending_pay_out]) }
  scope :recontributed, -> { where(status: %i[issued manually_recontributed auto_recontributed]) }

  private

  def log_status_change
    message = case status.to_sym
              when :pending_pay_out then "Payout requested by #{member.user.email}"
              when :manually_recontributed then "Dividend manually recontributed by #{member.user.email}"
              when :auto_recontributed then "Dividend automatically recontributed for #{member.user.email}"
              when :pay_out_complete then nil
              end
    ActivityLog.create(message:) if message
  end

  scope :automatically_recontributed_notify_enabled, lambda {
    joins(member: :notification_preferences)
      .where(notification_preferences: {
        id: NotificationPreference.dividend_automatically_recontributed,
        enabled: true
      })
  }
end

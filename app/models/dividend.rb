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

  scope :owed, -> { where(status: %i[pending_pay_out]) }
  scope :recontributed, -> { where(status: %i[issued manually_recontributed auto_recontributed]) }

  scope :automatically_recontributed_notify_enabled, lambda {
    joins(member: :notification_preferences)
      .where(notification_preferences: {
        id: NotificationPreference.dividend_automatically_recontributed,
        enabled: true
      })
  }
end

class NotificationPreference < ApplicationRecord
  belongs_to :member

  validates :notification_name, uniqueness: { scope: :member_id }

  enum :notification_name, {
    contribution_received: 0,
    dividend_received: 1,
    dividend_paid_out: 2,
    dividend_automatically_recontributed: 3,
    distribution_settled: 4,
    distribution_preview: 5
  }
end

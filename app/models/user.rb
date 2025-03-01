class User < ApplicationRecord
  ADMIN_EMAIL = ENV['ADMIN_EMAIL'] || "admin@#{ENV.fetch('DOMAIN', nil)}".freeze

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :trackable

  has_one :member, dependent: :destroy

  scope :admin, lambda {
    where(email: ADMIN_EMAIL)
  }

  scope :active, lambda {
    admin.invert_where
      .where.not(last_sign_in_at: nil)
  }

  scope :inactive, lambda {
    admin.invert_where
      .where(last_sign_in_at: nil)
  }

  scope :distribution_preview_notify_enabled, lambda {
    joins(member: :notification_preferences)
      .where(notification_preferences: {
        id: NotificationPreference.distribution_preview,
        enabled: true
      })
  }

  scope :distribution_settled_notify_enabled, lambda {
    joins(member: :notification_preferences)
      .where(notification_preferences: {
        id: NotificationPreference.distribution_settled,
        enabled: true
      })
  }

  def admin?
    email == ADMIN_EMAIL
  end
end

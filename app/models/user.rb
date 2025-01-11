class User < ApplicationRecord
  ADMIN_EMAIL = ENV['ADMIN_EMAIL'] || "admin@#{ENV.fetch('DOMAIN', nil)}".freeze

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :trackable

  has_one :member, dependent: :destroy

  scope :active, lambda {
    where.not(email: ADMIN_EMAIL)
      .where.not(last_sign_in_at: nil)
  }

  scope :inactive, lambda {
    where.not(email: ADMIN_EMAIL)
      .where(last_sign_in_at: nil)
  }

  scope :distribution_preview_notify_enabled, lambda {
    joins(member: :notification_preferences)
      .where(notification_preferences: {
        id: NotificationPreference.distribution_preview,
        enabled: true
      })
  }

  def admin?
    email == ADMIN_EMAIL
  end
end

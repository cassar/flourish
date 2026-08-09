class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :nullify
  has_many :contributions, dependent: :nullify
  has_many :notification_preferences, dependent: :destroy

  has_many :pool_memberships, dependent: :destroy
  has_many :pools, through: :pool_memberships
  has_many :contributor_pool_memberships, -> { contributor }, class_name: 'PoolMembership',
                                                              dependent: :destroy, inverse_of: :member
  has_many :contributor_pools, through: :contributor_pool_memberships, source: :pool
  has_many :recipient_pool_memberships, -> { recipient }, class_name: 'PoolMembership',
                                                          dependent: :destroy, inverse_of: :member
  has_many :recipient_pools, through: :recipient_pool_memberships, source: :pool

  accepts_nested_attributes_for :notification_preferences

  validates :paypalme_handle, uniqueness: { allow_nil: true, case_sensitive: false }
  encrypts :paypalme_handle, deterministic: true, downcase: true

  include CurrencyValidator

  scope :active, lambda {
    joins(:user).merge(User.active)
  }

  scope :inactive, lambda {
    joins(:user).merge(User.inactive)
  }

  def pay_outs_disabled?
    paypalme_handle.blank?
  end

  def create_notification_preferences!
    NotificationPreference.notification_names.each_key do |notification_name|
      notification_preferences.create! notification_name:
    end
  end
end

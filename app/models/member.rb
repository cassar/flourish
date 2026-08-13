class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :nullify
  has_many :contributions, dependent: :nullify
  has_many :notification_preferences, dependent: :destroy

  has_many :pod_memberships, dependent: :destroy
  has_many :pods, through: :pod_memberships
  has_many :contributor_pod_memberships, -> { contributor }, class_name: 'PodMembership',
                                                             dependent: :destroy, inverse_of: :member
  has_many :contributor_pods, through: :contributor_pod_memberships, source: :pod
  has_many :recipient_pod_memberships, -> { recipient }, class_name: 'PodMembership',
                                                         dependent: :destroy, inverse_of: :member
  has_many :recipient_pods, through: :recipient_pod_memberships, source: :pod

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

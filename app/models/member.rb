class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :nullify
  has_many :contributions, dependent: :nullify
  has_many :notification_preferences, dependent: :destroy

  has_many :pot_memberships, dependent: :destroy
  has_many :pots, through: :pot_memberships
  has_many :contributor_pot_memberships, -> { contributor }, class_name: 'PotMembership',
                                                             dependent: :destroy, inverse_of: :member
  has_many :contributor_pots, through: :contributor_pot_memberships, source: :pot

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

  def display_name
    name.presence || "Member #{id}"
  end

  def pay_outs_disabled?
    paypalme_handle.blank?
  end

  def create_notification_preferences!
    NotificationPreference.notification_names.each_key do |notification_name|
      notification_preferences.create! notification_name:
    end
  end
end

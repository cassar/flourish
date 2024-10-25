class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :nullify
  has_many :contributions, dependent: :nullify

  validates :paypalme_handle, uniqueness: { allow_nil: true, case_sensitive: false }

  validates :paypalme_handle_new, uniqueness: { allow_nil: true, case_sensitive: false }
  encrypts :paypalme_handle_new, deterministic: true, downcase: true

  scope :active, lambda {
    joins(:user).merge(User.active)
  }

  scope :inactive, lambda {
    joins(:user).merge(User.inactive)
  }

  def pay_outs_disabled?
    paypalme_handle.blank?
  end
end

class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :nullify
  has_many :contributions, dependent: :nullify

  validates :paypalmeid, uniqueness: { allow_nil: true, case_sensitive: false }

  scope :active, lambda {
    joins(:user)
      .where.not(users: { email: User::ADMIN_EMAIL })
      .where.not(users: { last_sign_in_at: nil })
  }

  scope :inactive, lambda {
    joins(:user)
      .where.not(users: { email: User::ADMIN_EMAIL })
      .where(users: { last_sign_in_at: nil })
  }

  def pay_outs_disabled?
    paypalmeid.blank?
  end
end

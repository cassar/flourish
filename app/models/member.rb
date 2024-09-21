class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :destroy
  has_many :contributions, dependent: :destroy

  validates :paypalmeid, uniqueness: true, allow_nil: true

  scope :active, lambda {
    joins(:user)
      .where.not(users: { email: User::ADMIN_EMAIL })
      .where.not(users: { last_sign_in_at: nil })
  }

  def pay_outs_disabled?
    paypalmeid.blank?
  end
end

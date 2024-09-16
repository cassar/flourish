class Member < ApplicationRecord
  belongs_to :user

  has_many :dividends, dependent: :destroy
  has_many :contributions, dependent: :destroy

  validates :paypalmeid, uniqueness: true, allow_nil: true

  scope :active, lambda {
    joins(:user)
      .where.not(users: { email: User::ADMIN_EMAIL })
  }

  def pay_outs_disabled?
    paypalmeid.blank?
  end

  private

  def dividend
    DividendService::NextDividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count:,
      total_pool: BankAccountService.balance
    )
  end
end

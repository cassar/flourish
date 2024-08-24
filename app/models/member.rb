class Member < ApplicationRecord
  MINIMUM_CONTRIBUTION_AMOUNT = 0

  belongs_to :user

  has_many :dividends, dependent: :destroy
  has_many :contributions, dependent: :destroy

  def pay_outs_disabled?
    paypalmeid.blank?
  end

  private

  def member_count
    ActiveMemberCountService.call
  end

  def dividend
    DividendService::NextDividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count:,
      total_pool: BankAccountService.balance
    )
  end
end

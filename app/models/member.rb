class Member < ApplicationRecord
  MINIMUM_CONTRIBUTION_AMOUNT = 0

  belongs_to :user

  has_many :dividends, dependent: :destroy

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

class Member < ApplicationRecord
  MINIMUM_CONTRIBUTION_AMOUNT = 0

  enum active: {
    inactive: 0,
    active: 1
  }

  validates :contribution_amount, numericality: { greater_than_or_equal_to: MINIMUM_CONTRIBUTION_AMOUNT }

  belongs_to :user

  after_save_commit do
    broadcast_replace_to 'member_count',
                         partial: 'dashboard/member_count',
                         locals: { member_count: },
                         target: 'member_count'
  end

  after_save_commit do
    broadcast_replace_to 'dividend_amount',
                         partial: 'dashboard/dividend_amount',
                         locals: { dividend_amount: dividend.amount_formatted },
                         target: 'dividend_amount'
  end

  def contribution_amount_formatted
    Money.from_amount(contribution_amount).format
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

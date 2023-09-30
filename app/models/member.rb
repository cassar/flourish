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
    broadcast_replace_to 'contribution_total',
                         partial: 'dashboard/contribution_total',
                         locals: { contribution_total: TotalContributionsService.formatted },
                         target: 'contribution_total'
  end

  after_save_commit do
    broadcast_replace_to 'dividend_amount',
                         partial: 'dashboard/dividend_amount',
                         locals: { dividend_amount: dividend.amount_formatted },
                         target: 'dividend_amount'
  end

  after_save_commit do
    broadcast_replace_to 'dividend_date',
                         partial: 'dashboard/dividend_date',
                         locals: { dividend_date: dividend.date_formatted },
                         target: 'dividend_date'
  end

  private

  def member_count
    ActiveMemberCountService.call
  end

  def dividend
    DividendService::NextDividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count:
    )
  end
end

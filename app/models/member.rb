class Member < ApplicationRecord
  MINIMUM_CONTRIBUTION_AMOUNT = 0

  enum active: {
    inactive: 0,
    active: 1
  }

  validates :contribution_amount, numericality: { greater_than_or_equal_to: MINIMUM_CONTRIBUTION_AMOUNT }

  belongs_to :user

  before_save :activate_or_deactivate_membership

  after_save_commit do
    broadcast_replace_to 'member_count',
                         partial: 'dashboard/member_count',
                         locals: { member_count: },
                         target: 'member_count'
  end

  def contribution_amount_formatted
    Money.from_amount(contribution_amount).format
  end

  private

  def activate_or_deactivate_membership
    self.active = if payid.present?
                    :active
                  else
                    :inactive
                  end
  end

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

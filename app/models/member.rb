class Member < ApplicationRecord
  belongs_to :user

  MINIMUM_CONTRIBUTION_AMOUNT = 0

  after_save_commit :broadcast_member_count, :broadcast_contribution_total,
    :broadcast_dividend_information

  validates :contribution_amount, numericality: { greater_than_or_equal_to: MINIMUM_CONTRIBUTION_AMOUNT }

  private

  def broadcast_member_count
    ActionCable.server.broadcast(
      MemberCountChannel::COMMON,
      {member_count: member_count}
    )
  end

  def broadcast_contribution_total
    ActionCable.server.broadcast(
      ContributionTotalChannel::COMMON,
      {contribution_total: TotalContributionsService.formatted}
    )
  end

  def broadcast_dividend_information
    ActionCable.server.broadcast(
      DividendInformationChannel::COMMON,
      {
        dividend_amount: dividend.amount_formatted,
        dividend_date: dividend.date_formatted
      }
    )
  end

  def dividend
    DividendService::Dividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count: member_count
    )
  end

  def member_count
    MemberCountService.call
  end
end

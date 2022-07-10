class Member < ApplicationRecord
  after_save_commit :broadcast_member_count, :broadcast_contribution_total,
    :broadcast_dividend_information

  validates :contribution_amount, numericality: { greater_than_or_equal_to: 0 }

  private

  def broadcast_member_count
    ActionCable.server.broadcast(
      MemberCountChannel::COMMON,
      {member_count: MemberCountService.call}
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
        dividend_amount: DividendService::Dividend.next_dividend_amount,
        dividend_date: DividendService::Dividend.next_dividend_date
      }
    )
  end
end

class Member < ApplicationRecord
  after_save_commit :broadcast_member_count, :broadcast_contribution_total

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
      {contribution_total: TotalContributionsService.call}
    )
  end
end

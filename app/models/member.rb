class Member < ApplicationRecord
  after_save_commit :broadcast_member_count

  validates :contribution_amount, numericality: { greater_than_or_equal_to: 0 }

  private

  def broadcast_member_count
    ActionCable.server.broadcast(
      MemberCountChannel::COMMON,
      {member_count: MemberCountService.call}
    )
  end
end

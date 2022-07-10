class Member < ApplicationRecord
  after_save_commit :broadcast_member_count

  private

  def broadcast_member_count
    ActionCable.server.broadcast(
      MemberCountChannel::COMMON,
      {member_count: MemberCountService.call}
    )
  end
end

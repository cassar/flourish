class MemberCountChannel < ApplicationCable::Channel
  COMMON = "common_member_count"

  def subscribed
    stream_from COMMON
  end
end

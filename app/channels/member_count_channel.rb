class MemberCountChannel < ApplicationCable::Channel
  COMMON = 'common_member_count'.freeze

  def subscribed
    stream_from COMMON
  end
end

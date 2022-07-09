class MemberGeneratorJob < ApplicationJob
  queue_as :default

  MAX_MEMBER_COUNT = 100

  def perform(*args)
    return Member.destroy_all if Member.count >= max_member_count

    Member.create!
    self.class.set(wait: 3.seconds).perform_later
  end

  def max_member_count
    MAX_MEMBER_COUNT
  end
end

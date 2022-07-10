class MemberGeneratorJob < ApplicationJob
  queue_as :default

  MAX_MEMBER_COUNT = 100
  MULTIPLIER = 100

  def perform(*args)
    return Member.destroy_all if Member.count >= max_member_count

    Member.create!(contribution_amount: contribution_amount)
    self.class.set(wait: 3.seconds).perform_later
  end

  def max_member_count
    MAX_MEMBER_COUNT
  end

  def contribution_amount
    Integer rand() * MULTIPLIER
  end
end

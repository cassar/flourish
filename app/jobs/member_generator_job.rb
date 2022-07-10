class MemberGeneratorJob < ApplicationJob
  queue_as :default

  MAX_MEMBER_COUNT = 100
  MULTIPLIER = 100
  CONTRIBUTION_RATIO = 1

  def perform(*args)
    return Member.destroy_all if stop?

    Member.create!(contribution_amount: contribution_amount)
    self.class.set(wait: 3.seconds).perform_later
  end

  def contribution_amount
    return 0 unless contribute?

    random_amount
  end

  def stop?
    member_count >= max_member_count
  end

  def contribute?
    (member_count % CONTRIBUTION_RATIO).zero?
  end

  def random_amount
    Integer(rand() * MULTIPLIER)
  end

  def member_count
    MemberCountService.call
  end

  def max_member_count
    MAX_MEMBER_COUNT
  end
end

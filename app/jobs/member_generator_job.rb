class MemberGeneratorJob < ApplicationJob
  queue_as :default

  MAX_MEMBER_COUNT = 100
  MULTIPLIER = 10
  CONTRIBUTION_RATIO = 100
  WAIT_TIME = 3.seconds

  def perform(*args)
    return clean_up if stop?

    create_new_member
    queue_again
  end

  def create_new_member
    Member.create!(contribution_amount: contribution_amount)
  end

  def queue_again
    self.class.set(wait: WAIT_TIME).perform_later
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

  def clean_up
    Member.destroy_all
  end

  def max_member_count
    MAX_MEMBER_COUNT
  end
end

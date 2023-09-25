class MemberGeneratorJob < ApplicationJob
  queue_as :default

  MAX_MEMBER_COUNT = 100
  CONTRIBUTION_AMOUNT_MULTIPLIER = 100
  CONTRIBUTING_MEMBER_RATIO = 5
  WAIT_TIME = 3.seconds

  def perform(*_args)
    return clean_up if stop?

    create_new_member
    queue_again
  end

  def create_new_member
    user = User.create!(email: "user#{random_hex}@example.com", password: 'password')
    user.member.active!
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
    (member_count % CONTRIBUTING_MEMBER_RATIO).zero?
  end

  def random_amount
    Integer(rand * CONTRIBUTION_AMOUNT_MULTIPLIER)
  end

  def member_count
    MemberCountService.call
  end

  def clean_up
    User.where.not(email: User::ADMIN_EMAIL).destroy_all
  end

  def max_member_count
    MAX_MEMBER_COUNT
  end

  def random_hex
    SecureRandom.hex(4)
  end
end

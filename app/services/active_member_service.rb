class ActiveMemberService
  def self.call
    Member.active.joins(:user).where.not(users: { confirmed_at: nil })
  end
end

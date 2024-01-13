class ActiveMemberService
  def self.call
    Member.joins(:user).where.not(users: { confirmed_at: nil })
  end
end

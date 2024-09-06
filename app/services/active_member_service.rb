class ActiveMemberService
  def self.call
    Member.joins(:user)
          .where.not(users: { confirmed_at: nil })
          .where.not(users: { email: User::ADMIN_EMAIL })
  end
end

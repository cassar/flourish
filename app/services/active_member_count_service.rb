class ActiveMemberCountService
  def self.call
    Member.active.count
  end
end

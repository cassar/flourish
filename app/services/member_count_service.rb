class MemberCountService
  def self.call
    Member.active.count
  end
end

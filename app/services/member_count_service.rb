class MemberCountService
  def self.call
    Member.count
  end
end

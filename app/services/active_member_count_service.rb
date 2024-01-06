class ActiveMemberCountService
  def self.call
    ActiveMemberService.call.count
  end
end

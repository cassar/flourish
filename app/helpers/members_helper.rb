module MembersHelper
  def member_display_name(member)
    member.name.presence || "Member #{member.id}"
  end
end

module Admin
  module MembersHelper
    def paypalmeid_emoji(paypalmeid)
      if paypalmeid.present?
        '💰'
      else
        '🚫'
      end
    end
  end
end

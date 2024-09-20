module Admin
  module UsersHelper
    def paypalmeid_emoji(paypalmeid)
      if paypalmeid.present?
        '💰'
      else
        '🚫'
      end
    end
  end
end

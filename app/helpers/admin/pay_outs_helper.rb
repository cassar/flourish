module Admin
  module PayOutsHelper
    def paypalme_url(paypalme_handle: '', amount_in_base_units: nil, currency: nil)
      return "https://www.paypal.me/paypalme/#{paypalme_handle}" if amount_in_base_units.nil?

      amount = Money.new(amount_in_base_units, currency).format(symbol: false).gsub(' ', '')
      "https://www.paypal.me/paypalme/#{paypalme_handle}/#{amount}"
    end
  end
end

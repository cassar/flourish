module Admin
  module PayOutsHelper
    def paypalme_url(paypalmeid:, amount_in_base_units: nil)
      return "https://paypal.me/#{paypalmeid}" if amount_in_base_units.nil?

      amount = Money.from_cents(amount_in_base_units).format(symbol: false).gsub(' ', '')
      "https://paypal.me/#{paypalmeid}/#{amount}"
    end
  end
end

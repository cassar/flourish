module Admin
  module PayOutsHelper
    def paypalme_url(paypalme_handle:, amount_in_base_units: nil, currency: nil)
      return "https://paypal.me/#{paypalme_handle}" if amount_in_base_units.nil?

      amount = Money.new(amount_in_base_units, currency).format(symbol: false).gsub(' ', '')
      "https://paypal.me/#{paypalme_handle}/#{amount}"
    end
  end
end

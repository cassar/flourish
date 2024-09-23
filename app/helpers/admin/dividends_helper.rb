module Admin
  module DividendsHelper
    def paypalme_url(paypalmeid:, amount_in_base_units:, dividend_id:)
      amount = Money.from_cents(amount_in_base_units).format(symbol: false).gsub(' ', '')
      note = URI.encode_www_form_component("Flourish Dividend ID: #{dividend_id}")

      "https://paypal.me/#{paypalmeid}/#{amount}?note=#{note}"
    end
  end
end

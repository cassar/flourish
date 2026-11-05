class DividendAmountService
  attr_accessor :total_pod_in_aud_base_units, :member_count

  def initialize(total_pod_in_aud_base_units:, member_count:)
    @total_pod_in_aud_base_units = total_pod_in_aud_base_units
    @member_count = member_count
  end

  def amount_in_aud_base_units
    return 0 if 0.in? [total_pod_in_aud_base_units, member_count]

    total_pod_in_aud_base_units / member_count
  end

  def amount_formatted(currency)
    CurrencyConverter.format_from_aud(amount_in_aud_base_units, currency)
  end
end

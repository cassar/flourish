class DividendAmountService
  attr_accessor :total_pool_in_base_units, :member_count

  def initialize(total_pool_in_base_units:, member_count:)
    @total_pool_in_base_units = total_pool_in_base_units
    @member_count = member_count
  end

  def amount_in_base_units
    return 0 if 0.in? [total_pool_in_base_units, member_count]

    total_pool_in_base_units / member_count
  end

  def amount_formatted(currency)
    Money.new(amount_in_base_units, 'AUD').exchange_to(currency).format
  end
end

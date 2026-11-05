class TotalPod
  attr_reader :pod

  def initialize(pod)
    @pod = pod
  end

  def balance_in_aud_base_units
    Integer(total_assets_in_aud_base_units - total_liabilites_in_aud_base_units)
  end

  def balance_formatted(currency)
    CurrencyConverter.format_from_aud(balance_in_aud_base_units, currency)
  end

  def total_contributed_and_recontributed_formatted(currency)
    TotalContributedAndRecontributedCalculator.formatted(pod, currency)
  end

  def total_paid_out_formatted(currency)
    TotalPayOutsCalculator.formatted(pod, currency)
  end

  def total_dividends_formatted(currency)
    TotalDividendsCalculator.formatted(pod, currency)
  end

  private

  def total_assets_in_aud_base_units
    total_contributed_in_aud_base_units
  end

  def total_liabilites_in_aud_base_units
    [
      total_owed_dividends_in_aud_base_units,
      total_paid_out_in_aud_base_units,
      total_pay_out_fees_in_aud_base_units
    ].sum
  end

  def total_contributed_in_aud_base_units
    TotalContributionsCalculator.aud_base_units(pod)
  end

  def total_owed_dividends_in_aud_base_units
    CurrencyConverter.in_aud_base_units total_owed_dividends_by_currency
  end

  def total_paid_out_in_aud_base_units
    CurrencyConverter.in_aud_base_units total_paid_out_by_currency
  end

  def total_pay_out_fees_in_aud_base_units
    CurrencyConverter.in_aud_base_units total_pay_out_fees_by_currency
  end

  def total_owed_dividends_by_currency
    TotalPodCalculations.total_owed_dividends_by_currency(pod)
  end

  def total_paid_out_by_currency
    TotalPodCalculations.total_paid_out_by_currency(pod)
  end

  def total_pay_out_fees_by_currency
    TotalPodCalculations.total_pay_out_fees_by_currency(pod)
  end
end

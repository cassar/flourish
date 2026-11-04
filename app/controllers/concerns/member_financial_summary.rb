module MemberFinancialSummary
  extend ActiveSupport::Concern

  private

  def member_dividends(limit:)
    @member.dividends
      .includes(:amount, :pay_out, :distribution)
      .joins(:amount)
      .order('amounts.created_at DESC')
      .limit(limit)
  end

  def total_contributed_formatted
    cents = @member.contributions.where(currency: 'AUD').sum(:amount_in_base_units)
    Money.new(cents, 'AUD').format(no_cents: true)
  end

  def total_dividends_formatted
    cents = @member.dividends
      .joins(:amount)
      .where(amounts: { currency: 'AUD' })
      .sum('amounts.amount_in_base_units')
    Money.new(cents, 'AUD').format(no_cents: true)
  end
end

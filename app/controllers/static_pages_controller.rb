class StaticPagesController < ApplicationController
  def home
    set_pool_data
    @distribution_count = Distribution.count
    @total_shared_compact = compact_money(Amount.where(currency: 'AUD').sum(:amount_in_base_units))
    @recent_activity = ActivityLog.order(created_at: :desc).limit(5)
  end

  private

  def set_pool_data
    pool_cents = Contribution.where(distribution_id: nil).sum(:amount_in_base_units)
    @member_count = Member.count
    per_bee_cents = @member_count.positive? ? pool_cents / @member_count : 0
    @pool_formatted = Money.new(pool_cents, 'AUD').format
    @per_bee_formatted = Money.new(per_bee_cents, 'AUD').format
  end

  def compact_money(cents)
    if cents >= 100_000_000
      "$#{format('%.1f', cents / 100_000_000.0)}M"
    elsif cents >= 100_000
      "$#{format('%.1f', cents / 100_000.0)}k"
    else
      Money.new(cents, 'AUD').format
    end
  end
end

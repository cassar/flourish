class StaticPagesController < ApplicationController
  def home
    set_pool_data
    @distribution_count = Distribution.count
    @total_shared_compact = compact_money(Amount.where(currency: 'AUD').sum(:amount_in_base_units))
    @recent_activity = ActivityLog.order(created_at: :desc).limit(20)
  end

  private

  def set_pool_data
    pool_cents = Contribution.where(distribution_id: nil).sum(:amount_in_base_units)
    @member_count = Member.count
    per_bee_cents = @member_count.positive? ? pool_cents / @member_count : 0
    @pool_formatted = format_aud(pool_cents)
    @per_bee_formatted = format_aud(per_bee_cents)
  end

  def compact_money(cents)
    if cents >= 100_000_000
      "$#{format('%.1f', cents / 100_000_000.0)}M"
    elsif cents >= 100_000
      "$#{format('%.1f', cents / 100_000.0)}k"
    else
      Money.new(cents, 'AUD').format(no_cents: true).delete_suffix(' AUD')
    end
  end

  def format_aud(cents)
    Money.new(cents, 'AUD').format.delete_suffix(' AUD')
  end
end

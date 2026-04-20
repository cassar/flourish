class StaticPagesController < ApplicationController
  def home
    @last_distribution = Distribution.last || Distribution.new(created_at: Time.zone.now)
    @last_amount = @last_distribution.default_amount || Amount.new(amount_in_base_units: 0)
    @last_distribution_dividends = @last_distribution.dividends
    @next_distribution = NextDistribution
    @total_pool = TotalPool
    @recent_activities = recent_activities
    authenticated_user
  end

  def about
    @active_member_count = Member.active.count
  end

  private

  def recent_activities
    (contributions + recontributions + distributions + pay_outs)
      .sort_by { |a| -a[:at].to_i }
      .first(15)
  end

  def contributions
    Contribution.order(created_at: :desc).limit(5).map do |c|
      { type: :contribution, label: "#{c.amount_formatted} contributed", at: c.created_at }
    end
  end

  def recontributions
    Dividend.where(status: %i[manually_recontributed auto_recontributed])
      .includes(:amount)
      .order(updated_at: :desc).limit(5).map do |d|
      { type: :recontribution, label: "#{d.amount.amount_formatted} recontributed", at: d.updated_at }
    end
  end

  def distributions
    Distribution.order(created_at: :desc).limit(5).map do |d|
      { type: :distribution, label: "Distribution #{d.name} issued", at: d.created_at }
    end
  end

  def pay_outs
    PayOut.order(created_at: :desc).limit(5).map do |p|
      { type: :pay_out, label: "#{p.amount_formatted} paid out", at: p.created_at }
    end
  end

  def authenticated_user
    @member = if user_signed_in?
                current_user.member
              else
                Member.new(currency: 'AUD')
              end
  end
end

module Admin
  class MembersController < Admin::BaseController
    def index
      @members = Member.includes(:user)
        .joins(:user)
        .merge(User.where.not(email: User::ADMIN_EMAIL))
        .order('users.email')
      return if params[:q].blank?

      @members = @members.where(
        'users.email LIKE :q OR members.name LIKE :q', q: "%#{params[:q]}%"
      )
    end

    def show
      @member = Member.includes(:user, :contributions, :dividends, :notification_preferences)
        .find(params.expect(:id))
      @dividends = member_dividends
      @contributions = @member.contributions.order(created_at: :desc).limit(20)
      @notification_preferences = @member.notification_preferences.order(:notification_name)
      @total_contributed = total_contributed_formatted
      @total_dividends = total_dividends_formatted
      @pending_payout_count = @member.dividends.pending_pay_out.count
    end

    private

    def member_dividends
      @member.dividends
        .includes(:amount, :pay_out, :distribution)
        .joins(:amount)
        .order('amounts.created_at DESC')
        .limit(20)
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
end

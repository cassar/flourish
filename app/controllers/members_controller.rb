class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    @pot = current_member.pots.find(params.expect(:pot_id))
    @membership = @pot.pot_memberships.find_by!(member_id: params.expect(:id))
    @member = @membership.member
    load_activity
  end

  private

  def load_activity
    @contributions = @member.contributions.where(pot: @pot).includes(:distribution).order(created_at: :desc)
    @dividends = @member.dividends.in_pot(@pot).includes(:pay_out, amount: :distribution).order(created_at: :desc)
  end
end

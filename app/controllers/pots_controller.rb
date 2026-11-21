class PotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pots = current_member.pots
      .left_joins(:pot_memberships)
      .select('pots.*, COUNT(pot_memberships.id) AS people_count')
      .group('pots.id')
      .order(:id)
  end

  def show
    @pot = current_member.pots.find(params.expect(:id))
    @memberships = @pot.pot_memberships.includes(:member).order(:id)
    @distributions = @pot.distributions.order(number: :desc)
  end

  def create
    pot = Pot.new
    pot.pot_memberships.build(member: current_member)
    pot.save!

    redirect_to pots_path, notice: t('controllers.pots.create.success')
  end
end

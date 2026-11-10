class PotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pots = current_member.pots
      .left_joins(:pot_memberships)
      .select('pots.*, COUNT(pot_memberships.id) AS people_count')
      .group('pots.id')
      .order(:id)
    @contributor_pot_ids = current_member.contributor_pot_ids
  end

  def show
    @pot = current_member.pots.find(params.expect(:id))
    @memberships = @pot.pot_memberships.includes(:member).order(:role, :id)
    @distributions = @pot.distributions.order(number: :desc)
  end

  def create
    pot = Pot.new
    pot.pot_memberships.build(member: current_member, role: :contributor)
    pot.save!

    redirect_to pots_path, notice: t('controllers.pots.create.success')
  end

  def destroy
    pot = current_member.contributor_pots.find(params.expect(:id))

    if history?(pot)
      redirect_to pots_path, alert: t('controllers.pots.destroy.has_history', id: pot.id)
    else
      pot.destroy!
      redirect_to pots_path, notice: t('controllers.pots.destroy.success'), status: :see_other
    end
  end

  private

  def current_member
    current_user.member
  end

  def history?(pot)
    pot.contributions.exists? || pot.distributions.exists?
  end
end

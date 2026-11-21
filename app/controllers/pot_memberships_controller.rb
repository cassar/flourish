class PotMembershipsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    membership = current_member.pot_memberships.find_by!(pot_id: params.expect(:pot_id))
    membership.destroy!

    redirect_to pots_path, notice: t('controllers.pot_memberships.destroy.success', id: membership.pot_id),
                           status: :see_other
  end
end

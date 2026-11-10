class DistributionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @pot = current_user.member.pots.find(params.expect(:pot_id))
    @distribution = @pot.distributions.find_by!(number: params.expect(:id))
    @dividends = @distribution.dividends
      .includes(:member, :pay_out, :amount)
      .order(:status, :id)
  end
end

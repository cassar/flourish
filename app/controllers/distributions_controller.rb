class DistributionsController < ApplicationController
  def show
    @pot = current_member.pots.find(params.expect(:pot_id))
    @distribution = @pot.distributions.find_by!(number: params.expect(:id))
    @dividends = @distribution.dividends
      .includes(:member, :pay_out, :amount)
      .order(:status, :id)
  end
end

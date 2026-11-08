class DistributionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @pod = current_user.member.pods.find(params.expect(:pod_id))
    @distribution = @pod.distributions.find_by!(number: params.expect(:id))
    @dividends = @distribution.dividends
      .includes(:member, :pay_out, :amount)
      .order(:status, :id)
  end
end

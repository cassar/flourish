class PodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pods = current_member.pods
      .left_joins(:pod_memberships)
      .select('pods.*, COUNT(pod_memberships.id) AS people_count')
      .group('pods.id')
      .order(:id)
    @contributor_pod_ids = current_member.contributor_pod_ids
  end

  def create
    pod = Pod.new
    pod.pod_memberships.build(member: current_member, role: :contributor)
    pod.save!

    redirect_to pods_path, notice: t('controllers.pods.create.success')
  end

  def destroy
    pod = current_member.contributor_pods.find(params.expect(:id))

    if history?(pod)
      redirect_to pods_path, alert: t('controllers.pods.destroy.has_history', id: pod.id)
    else
      pod.destroy!
      redirect_to pods_path, notice: t('controllers.pods.destroy.success'), status: :see_other
    end
  end

  private

  def current_member
    current_user.member
  end

  def history?(pod)
    pod.contributions.exists? || pod.distributions.exists?
  end
end

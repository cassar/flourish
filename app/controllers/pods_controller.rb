class PodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pod, only: %i[edit update destroy]

  def index
    @pods = current_member.pods
      .left_joins(:pod_memberships)
      .select('pods.*, COUNT(pod_memberships.id) AS people_count')
      .group('pods.id')
      .order(:name)
    @contributor_pod_ids = current_member.contributor_pod_ids
  end

  def new
    @pod = Pod.new
  end

  def edit; end

  def create
    @pod = Pod.new(pod_params)
    @pod.pod_memberships.build(member: current_member, role: :contributor)

    if @pod.save
      redirect_to pods_path, notice: t('controllers.pods.create.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @pod.update(pod_params)
      redirect_to pods_path, notice: t('controllers.pods.update.success')
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @pod.contributions.exists? || @pod.distributions.exists?
      redirect_to pods_path, alert: t('controllers.pods.destroy.has_history', name: @pod.name)
    else
      @pod.destroy!
      redirect_to pods_path, notice: t('controllers.pods.destroy.success'), status: :see_other
    end
  end

  private

  def current_member
    current_user.member
  end

  def set_pod
    @pod = current_member.contributor_pods.find(params.expect(:id))
  end

  def pod_params
    params.expect(pod: [:name])
  end
end

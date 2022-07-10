class ContributionTotalChannel < ApplicationCable::Channel
  COMMON = "common_contribution_total"

  def subscribed
    stream_from COMMON
  end
end

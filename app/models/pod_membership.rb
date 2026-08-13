class PodMembership < ApplicationRecord
  belongs_to :pod
  belongs_to :member

  enum :role, { contributor: 0, recipient: 1 }

  validates :member_id, uniqueness: { scope: :pod_id }
  validate :only_one_contributor_per_pod, if: :contributor?

  private

  def only_one_contributor_per_pod
    return unless pod.pod_memberships.contributor.where.not(id:).exists?

    errors.add(:pod, :already_has_contributor)
  end
end

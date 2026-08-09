class BackfillPoolsFromHistoricalData < ActiveRecord::Migration[8.2]
  def up
    admin_email = Rails.application.credentials.admin_email || 'admin@flourish.test'
    admin_member = Member.joins(:user).find_by(users: { email: admin_email })
    return unless admin_member

    contributing_member_ids = Contribution.distinct.pluck(:member_id).compact
    original_recipient_member_ids = Dividend.distinct.pluck(:member_id).compact - [admin_member.id]

    # The old global unique index on distributions.number is still in effect at this
    # point in the migration sequence (it becomes per-pool in the finalize migration),
    # so newly created distributions here must keep drawing globally-unique numbers.
    next_number = Distribution.maximum(:number).to_i

    # One pool per historically contributing member: they are the sole contributor,
    # admin is the sole recipient, and each of their contributions becomes its own
    # distribution/dividend/payout cycle within that pool.
    Member.where(id: contributing_member_ids).find_each do |member|
      pool = Pool.create!(name: "#{member.user.email} — historical contributions")
      PoolMembership.create!(pool:, member:, role: :contributor)
      PoolMembership.create!(pool:, member: admin_member, role: :recipient) unless member.id == admin_member.id

      member.contributions.where(pool_id: nil).order(:created_at).each do |contribution|
        next_number += 1
        distribution = Distribution.create!(number: next_number, pool:)
        amount = distribution.amounts.create!(
          currency: contribution.currency,
          amount_in_base_units: contribution.amount_in_base_units
        )
        dividend = amount.dividends.create!(member: admin_member, status: :pay_out_complete)
        PayOut.create!(
          dividend:,
          currency: contribution.currency,
          amount_in_base_units: contribution.amount_in_base_units,
          fees_in_base_units: 0,
          transaction_identifier: "legacy-contribution-#{contribution.id}"
        )
        contribution.update!(pool:)
      end
    end

    # The pre-existing global distributions/dividends/payouts become one "general"
    # pool: admin is the contributor, and everyone who ever received a dividend
    # under the old global pool is a recipient.
    general_pool = Pool.create!(name: 'General distribution pool')
    PoolMembership.create!(pool: general_pool, member: admin_member, role: :contributor)
    Member.where(id: original_recipient_member_ids).find_each do |member|
      PoolMembership.create!(pool: general_pool, member:, role: :recipient)
    end

    Distribution.where(pool_id: nil).update_all(pool_id: general_pool.id)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

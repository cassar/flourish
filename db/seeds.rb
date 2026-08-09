# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Shaped to roughly mirror production (as of 2026-08): ~18 members, ~55% with a
# paypalme_handle, a handful of contributing members with multiple contributions
# each, multi-currency dividend fan-out, and dividend outcomes dominated by
# auto-recontribution with a smaller mix of payouts and manual recontributions.

puts "Making an admin"
admin = User.new(email: User::ADMIN_EMAIL, password: 'password')
admin.skip_confirmation_notification!
admin.skip_reconfirmation!
admin.confirm
admin.save!
admin.create_member!
admin.member.create_notification_preferences!

puts "Making some users"
SEED_CURRENCIES = %w[AUD USD EUR GBP CAD].freeze

members = (1..10).map do |i|
  user = User.new(email: "user_#{i}@email.com", password: "password")
  user.skip_confirmation_notification!
  user.skip_reconfirmation!
  user.save!
  user.create_member!
  member = user.member
  member.create_notification_preferences!

  next member if (i % 5).zero? # leave a couple of members unconfirmed/inactive, as in production

  user.confirm
  user.update! last_sign_in_at: Time.current

  member.update!(
    currency: SEED_CURRENCIES.sample,
    paypalme_handle: i.even? ? "paypalme_handle_member#{member.id}" : nil
  )
  member
end

puts "Making some pools"
# Mirrors production's structure: one pool per contributing member (they are the
# sole contributor, admin is the sole recipient), plus a general pool (admin is
# the sole contributor, everyone else is a recipient) that runs the weekly
# distribution/dividend cycle.
contributing_members = members.first(6)
contributor_pools = contributing_members.index_with do |member|
  pool = Pool.create!(name: "#{member.user.email} contributions")
  PoolMembership.create!(pool:, member:, role: :contributor)
  PoolMembership.create!(pool:, member: admin.member, role: :recipient)
  pool
end

general_pool = Pool.create!(name: 'General Pool')
PoolMembership.create!(pool: general_pool, member: admin.member, role: :contributor)
members.each do |member|
  PoolMembership.create!(pool: general_pool, member:, role: :recipient)
end

puts "Making some contributions"
contributing_members.each do |member|
  pool = contributor_pools[member]

  rand(1..3).times do |n|
    contribution = member.contributions.create!(
      amount_in_base_units: rand(500..10_000),
      fees_in_base_units: rand(0..50),
      pool:
    )
    contribution.update! transaction_identifier: "seed-contribution-#{contribution.id}-#{n}"
  end
end

puts "Making some distributions and dividends"
active_members = general_pool.recipients.merge(Member.active).to_a

(1..6).each do |number|
  distribution = Distribution.create! number:, pool: general_pool

  total_pool_in_aud_base_units = rand(5_000..50_000)
  dividend_amount = DividendAmountService.new(
    total_pool_in_aud_base_units:,
    member_count: active_members.count
  ).amount_in_aud_base_units

  amounts = DividendAmountsService.new(amount_in_base_units: dividend_amount, currency: 'AUD').call
  amounts.each { |amount| amount.update!(distribution:) }

  dividends = MemberDividendService.new(members: active_members, amounts:).call

  dividends.each do |dividend|
    if dividend.member.pay_outs_disabled?
      dividend.update! status: :auto_recontributed
      next
    end

    case rand
    when 0...0.1
      dividend.update! status: :pending_pay_out
      PayOut.create!(
        dividend:,
        amount_in_base_units: dividend.amount.amount_in_base_units,
        transaction_identifier: "seed-payout-#{dividend.id}"
      )
      dividend.update! status: :pay_out_complete
    when 0.1...0.15
      dividend.update! status: :manually_recontributed
    when 0.15...0.9
      dividend.update! status: :auto_recontributed
    end
    # remaining ~10% stay "issued", matching production's mix of not-yet-settled dividends
  end
end

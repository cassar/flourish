# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#

puts "Making an admin"
admin = User.new(email: User::ADMIN_EMAIL, password: 'password')
admin.skip_confirmation_notification!
admin.skip_reconfirmation!
admin.confirm
admin.save!
admin.create_member!
admin.member.create_notification_preferences!

puts "Making some users"
1..5.times do |integer|
  user = User.new(email: "user_#{integer}@email.com", password: "password")
  user.skip_confirmation_notification!
  user.skip_reconfirmation!
  user.save!
  user.create_member!
  user.member.create_notification_preferences!
  next if (user.id % 5).zero? 

  user.confirm
  user.last_sign_in_at = Time.now
  user.save!

  user.member.update! paypalme_handle: "paypalme_handle_member#{user.member.id}"
end

puts "Making some contributions"
Member.take(10).each do |member|
  contribution = member.contributions.create amount_in_base_units: 20_000 + (member.id * 10), fees_in_base_units: (member.id * 15)
  contribution.update! transaction_identifier: "anraba#{contribution.id}2741"
end

puts "Making some distributions"
(1..3).each do |number|
  distribution = Distribution.create(number:)

  amount_in_base_units = 1_000 * number
  amount = distribution.amounts.create!(amount_in_base_units:)

  Member.take(3).each do |member|
    dividend = amount.dividends.create!(member:)
    next if (member.id % 2).zero?

    PayOut.create! dividend:, amount_in_base_units:, transaction_identifier: "reference for dividend: #{dividend.id}"
  end
end

puts "Making some expenses"
Expense.create! name: "Server", amount_in_base_units: 334
Expense.create! name: "Domain", amount_in_base_units: 678

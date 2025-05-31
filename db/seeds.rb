# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

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



puts "Making some expenses, contributions, and distributions"
(1..3).each do |number|
  Member.take(2).each do |member|
    contribution = member.contributions.create amount_in_base_units: 20_000 + (member.id * 10), fees_in_base_units: (member.id * 15)
    contribution.update! transaction_identifier: "anraba#{contribution.id}2741"
  end

  Expense.create! name: "Hosting and Infrastructure", amount_in_base_units: 889
  Expense.create! name: "Domain Registration", amount_in_base_units: 116

  distribution = Distribution.create(number:)

  amount_in_base_units = 1_000 * number
  amount = distribution.amounts.create!(amount_in_base_units:)
  (Currencies::SUPPORTED - [Currencies::DEFAULT]).each do |currency|
    amount = distribution.amounts.create!(amount_in_base_units:, currency:)
  end

  Member.take(3).each do |member|
    dividend = amount.dividends.create!(member:)
    next if (member.id % 2).zero?

    PayOut.create! dividend:, amount_in_base_units:, transaction_identifier: "reference for dividend: #{dividend.id}"
  end
end

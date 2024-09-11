# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#

admin = User.new(email: User::ADMIN_EMAIL)
admin.skip_confirmation_notification!
admin.skip_reconfirmation!
admin.confirm
admin.save!

1..50.times do |integer|
  user = User.new(email: "user_#{integer}@email.com")
  user.skip_confirmation_notification!
  user.skip_reconfirmation!
  user.confirm
  user.save!
end

Contribution.create member: Member.first, amount_in_base_units: 20_000

3.times do |integer|
  distribution = Distribution.create(dividend_amount_in_base_units: 1_000)

  Member.take(3).each do |member|
    Dividend.create member:, distribution:
  end
end

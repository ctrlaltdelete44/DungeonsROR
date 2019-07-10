# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Account.create!(display_name: "ctrlaltdelete44",
				 email: "daviesanthonye1234@gmail.com",
				 password: "password",
				 password_confirmation: "password",
				 admin: true,
				 activated: true,
				 activated_at: Time.zone.now)

99.times do |n|
	name = Faker::Name.name
	email = "example-#{n+1}@stockuser.org"
	password = "password"
	Account.create!(display_name: name,
					 email: email,
					 password: password,
					 password_confirmation: password,
					 activated: true,
					activated_at: Time.zone.now)
end


accounts = Account.order(:created_at).take(6)
50.times do
	content = Faker::Lorem.sentence(5)
	accounts.each {
		|account| account.microposts.create!(content: content)
	}
end

#following relationships
accounts = Account.all
account = accounts.first
following = accounts[2..50]
followers = accounts[3..40]

following.each { |followed| account.follow(followed) }
followers.each { |follower| follower.follow(account) }
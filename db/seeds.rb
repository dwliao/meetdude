# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "這個種子檔會自動建立30個帳號"

30.times do
  User.create(
    email: Faker::Internet.email,
    name: Faker::Name.name,
    password: 123456,
    password_confirmation: 123456
  )
end

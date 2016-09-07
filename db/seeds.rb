# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_number = 10
posts_number_per_user = 10

puts "Create #{user_number} users and #{posts_number_per_user} posts for each user"

user = User.create(
  email: 'test@mail.com',
  name: 'test',
  password: 123456,
  password_confirmation: 123456)

user_number.times do
  user = User.create(
    email: Faker::Internet.email,
    name: Faker::Name.name,
    password: 123456,
    password_confirmation: 123456)
  posts_number_per_user.times do
    user.posts.create(
      title: Faker::Hipster.sentence,
      description: Faker::Hipster.paragraph)
  end
end
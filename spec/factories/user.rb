require "faker"

FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    name                  { Faker::Name.name }
    password              { "123456"}
    password_confirmation { "123456"}

    factory :user_two do
      email                 { "dd@email.com" }
      name                  { "abc" }
      password              { "12345678"}
      password_confirmation { "12345678"}
    end
  end
end

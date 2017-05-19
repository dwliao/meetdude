require "faker"

FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    name                  { Faker::Name.name }
    password              { "12345678" }
    password_confirmation { "12345678" }
  end
end

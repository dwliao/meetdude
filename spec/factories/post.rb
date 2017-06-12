FactoryGirl.define do
  factory :post do
    description { "description" }
    user
    target_id 1
  end
end

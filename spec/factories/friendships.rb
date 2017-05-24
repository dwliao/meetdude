FactoryGirl.define do
  factory :friendship do
    user
    friend_id 1
    state "pending"
  end
end

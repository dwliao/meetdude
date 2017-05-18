FactoryGirl.define do
  factory :notification do
    user
    notice_type ""
    post
    is_read false
  end
end

require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject(:user1) { User.create(email: Faker::Internet.email,
                                name: Faker::Name.name,
                                password: '123456',
                                password_confirmation: '123456')}
  subject(:user2) { User.create(email: Faker::Internet.email,
                                name: Faker::Name.name,
                                password: '12345678',
                                password_confirmation: '12345678')}
    #before { @post1_2 = user1.posts.create(description: "hello", :target => user2) }
    #before { sign_in(user1, scope: :user) }
  subject(:post1_2) { user1.posts.create(description: "1", :target => user2) }
  subject(:post2_1) { user2.posts.create(description: "2", :target => user1) }

  describe "notification.notice_target can find the user who received notification " do
    before { @notification1_2 = user1.notifications.create(:notice_target => user2) }

    it { expect(@notification1_2.notice_target).to eq(user2) }
    it { expect(@notification1_2.notice_target).not_to eq(user1) }
    end

  describe "notification.post can find the user's post" do
    before { @notification1_2 = user1.notifications.create(:post => post1_2) }
    before { @notification2_1 = user2.notifications.create(:post => post2_1) }

    it { expect(@notification1_2.post).to eq(post1_2) }
    it { expect(@notification1_2.post).not_to eq(post2_1) }
    it { expect(@notification2_1.post).to eq(post2_1) }
    it { expect(@notification2_1.post).not_to eq(post1_2)}
  end
end

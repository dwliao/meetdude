require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject(:user1) { create(:user) }
  subject(:user2) { create(:user_two)}
  subject(:post1_2) { user1.posts.new(description: "1", :target => user2) }
  subject(:post2_1) { user2.posts.new(description: "2", :target => user1) }
  subject(:post1)   { user1.posts.new(description: "2", :target => user1) }
  subject(:post2)   { user2.posts.new(description: "3") }

  #before { sign_in(user1, scope: :user) }

  describe "#post can find the user's post" do
    before {post1_2.save}
    before {post2_1.save}
    before {post1.save}
    before {post2.save}
    let(:notification1_2) { Notification.find_by(post_id: post1_2.id) }
    let(:notification2_1) { Notification.find_by(post_id: post2_1.id) }

    it { expect(notification1_2.post).to eq(post1_2) }
    it { expect(notification1_2.post).not_to eq(post2_1) }
    it { expect(notification2_1.post).to eq(post2_1) }
    it { expect(notification2_1.post).not_to eq(post1_2) }
  end

  context "When post save" do
    it "not generate notification when post.user_id = post.target_id" do
      post1.save
      post2.save
      expect( Notification.all.size ).to eq(0)
      expect( Notification.all.size ).not_to eq(1)
    end

    it "generate notification when post.user_id != post.target_id" do
      post1_2.save
      post2_1.save
      post1.save
      post2.save
      expect(Notification.all.size).to eq(2)
      expect(Notification.all.size).not_to eq(4)
      expect(Notification.all.size).not_to eq(0)
    end

    it "should receive notification by who receive post" do
      post1_2.save
      post1.save
      post2.save
      expect(user2.notifications.length).to eq(1)
      expect(user1.notifications.length).to eq(0)
    end
  end

  context "When notification is read" do
    before {post2_1.save}
    let(:notification2_1) { Notification.find_by(post_id: post2_1.id) }
    it "#have_read will update is_read become true" do
      notification2_1.have_read
      expect(notification2_1.is_read) == true
      expect(notification2_1.is_read) != false
    end

    it "#read? will show true or false" do
      expect(notification2_1.read?) == false
      expect(notification2_1.read?) != true
    end
  end

end

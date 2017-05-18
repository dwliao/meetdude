require 'rails_helper'

RSpec.describe Notification, type: :model do
  #before { sign_in(user1, scope: :user) }

    before do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @post1 = FactoryGirl.build :post, user: @user1
      @post2 = FactoryGirl.build :post, user: @user2
      @post1_2 = FactoryGirl.build :post, user: @user1, :target => @user2
      @post2_1 = FactoryGirl.build :post, user: @user2, target_id: @user1.id
    end

    context "When post save" do
      before(:each) do
        @post1.save
        @post2.save
        @post1_2.save
        @post2_1.save
        @notification1_2 = Notification.find_by(post_id: @post1_2)
        @notification2_1 = Notification.find_by(post_id: @post2_1)
      end

      it "not generate notification if post to self" do
        expect(Notification.find_by(post_id: @post1.id).present?).to eq false
        expect(Notification.find_by(post_id: @post2.id).present?).to eq false
      end

      it "generate notification if post to others" do
        expect(@notification1_2.present?).to eq true
        expect(@notification2_1.present?).to eq true
      end

      it "receive notification by who receive post" do
        expect(@notification1_2.user).to eq @user2
        expect(@notification2_1.user).to eq @user1
      end

      it "#post can show the post" do
        expect(@notification1_2.post).to eq @post1_2
        expect(@notification2_1.post).to eq @post2_1
      end

      it "#have_read? can update column of is_read become true" do
        @notification1_2.have_read
        expect(@notification1_2.is_read) == true
        expect(@notification1_2.is_read) != false
        expect(@notification2_1.is_read) == false
        expect(@notification2_1.is_read) != true
      end

      it "#read? show true or false" do
        expect(@notification1_2.read?) == false
        expect(@notification2_1.read?) == false
        expect(@notification1_2.read?) != true
        expect(@notification2_1.read?) != true
      end
    end
end

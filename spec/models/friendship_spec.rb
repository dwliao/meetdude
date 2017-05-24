require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @user1 = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user
    @user3 = FactoryGirl.create :user
    @friendship1_2 = FactoryGirl.create :friendship, user: @user1, friend_id: @user2.id
    @friendship1_3 = FactoryGirl.create :friendship, user: @user1, friend_id: @user3.id
    @friendship2_3 = FactoryGirl.create :friendship, user: @user2, friend_id: @user3.id
  end

  it { should respond_to(:user_id) }
  it { should respond_to(:friend_id) }
  it { should respond_to(:state) }

  it { should belong_to(:user) }

  describe "#accepted_friend!" do
    before(:each) do
      @friendship1_2.accepted_friend!
    end
    it { expect(@friendship1_2.state).to eq "accepted" }
    it { expect(@friendship1_2.state).not_to eq "pending" }
  end

  describe "#all_friends" do
    context "when state is accepted" do
      before(:each) do
        @friendship1_3.update_columns(state: "accepted")
        @friendship2_3.update_columns(state: "accepted")
      end
      it "user can find all friends" do
        expect(@user1.all_friends).to include(@user3)
        expect(@user1.all_friends).not_to include(@user2)
        expect(@user2.all_friends).to include(@user3)
      end

      it "the other(friend) can find all friends" do
        expect(@user3.all_friends).to include(@user1)
        expect(@user3.all_friends).to include(@user2)
      end

      it { expect(@user1.all_friends.length).to eq 1 }
      it { expect(@user2.all_friends.length).to eq 1 }
      it { expect(@user3.all_friends.length).to eq 2 }
    end
  end

end

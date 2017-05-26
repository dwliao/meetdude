require 'rails_helper'

RSpec.describe Api::V1::FriendshipsController, type: :controller do
  before(:each) do
    @user1 = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user
    @user3 = FactoryGirl.create :user
    @user4 = FactoryGirl.create :user
  end

  describe "GET #index" do
    before(:each) do
      current_user = @user1
      @friendship1_2 = FactoryGirl.create :friendship, user: current_user, friend: @user2
      @friendship1_3 = FactoryGirl.create :friendship, user: current_user, friend: @user3, state: "accepted"
      @friendship4_1 = FactoryGirl.create :friendship, user: @user4, friend_id: current_user.id
      api_authorization_header current_user.auth_token
      get :index, user_id: current_user.id
    end

    it "returns 3 records from the database" do
      friendship_response = json_response
      expect(friendship_response.length).to eq 3
    end

    it { expect(response).to have_http_status 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before do
        current_user = @user1
        @friendship_attributes = { friend_id: @user2.id }
        api_authorization_header current_user.auth_token
        post :create, { user_id: current_user.id, friendship: @friendship_attributes }
      end

      it "renders the json records presentation for the record just created" do
        friendship_response = json_response
        expect(friendship_response[:user_id]).to eq @friendship_attributes[:user_id]
      end

      it "renders the json message that 邀清已送出" do
        friendship_response = json_response
        expect(friendship_response[:message]).to eq "好友邀請已送出"
      end

      it { expect(response).to have_http_status 201 }
    end

    context "when is not created" do
      before do
        current_user = @user1
        @invalid = { friend_id: current_user.id }
        api_authorization_header current_user.auth_token
        post :create, { user_id: current_user.id, friendship: @invalid }
      end

      it "renders an error json" do
        friendship_response = json_response
        expect(friendship_response).to have_key(:errors)
      end

      it "renders the json error why the user can't send friend request" do
        friendship_response = json_response
        expect(friendship_response[:errors]).to eq "Can't add yourself to be friend"
      end

      it { expect(response).to have_http_status 422 }
    end
  end
end

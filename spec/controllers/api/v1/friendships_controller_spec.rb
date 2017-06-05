require 'rails_helper'

RSpec.describe Api::V1::FriendshipsController, type: :controller do

  before(:each) do
    @current_user = FactoryGirl.create :user
    @user = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user
    @user3 = FactoryGirl.create :user
    @user4 = FactoryGirl.create :user
    @user5 = FactoryGirl.create :user
    api_authorization_header @current_user.auth_token
  end

  describe "GET #show_friendship" do

    before(:each) do
      @friendship = FactoryGirl.create :friendship, user: @current_user, friend_id: @user.id
    end

    context "when current_user to user2 pages" do
      before do
        get :show_friendship, id: @user.id
      end

      it "returns their friendship records" do
        show_friendship_response = json_response
        expect(show_friendship_response[:id]).to be_present
        expect(show_friendship_response[:friend_id]).to eq @user.id
      end

      it { expect(response).to have_http_status 200 }
    end

    context "when current_user to user3 pages" do
      before do
        get :show_friendship, id: @user2.id
      end

      it "returns their relationship records" do
        show_friendship_response = json_response
        expect(show_friendship_response[:state]).to eq "not_relation"
      end

      it { expect(response).to have_http_status 200 }
    end
  end


  describe "POST #friend_request" do

    context "when request to be friend" do
      before(:each) do
        post :friend_request, { id: @user.id }
      end
      it "renders the json records presentation for the friendship record just created" do
        friend_request_response = json_response
        expect(friend_request_response[:id]).to be_present
        expect(friend_request_response[:user_id]).to eq @current_user.id
        expect(friend_request_response[:friend_id]).to eq @user.id
      end

      it { expect(response).to have_http_status 201 }
    end

    context "when on my own page" do
      before(:each) do
        post :friend_request, { id: @current_user.id }
      end
      it "renders the error json" do
        friend_request_response = json_response
        expect(friend_request_response).to have_key(:errors)
      end
      it "renders the json errors on why the request_friend could not be sent" do
        friend_request_response = json_response
        expect(friend_request_response[:errors]).to eq "Can't send friend request to yourself"
      end

      it { expect(response).to have_http_status 422 }
    end
  end

  describe "GET #index_friendships" do

    context "when current_user get all friendships which state are pending" do
      before(:each) do
        @friendship1 = FactoryGirl.create :friendship, user: @user, friend_id: @current_user.id
        @friendship2 = FactoryGirl.create :friendship, user: @user2, friend_id: @current_user.id
        @friendship3 = FactoryGirl.create :friendship, user: @user3, friend_id: @current_user.id
        @friendship4 = FactoryGirl.create :friendship, user: @user4, friend_id: @current_user.id, state: "accepted"
        @friendship5 = FactoryGirl.create :friendship, user: @current_user, friend_id: @user5.id
        get :index_friendships
      end

      it "returns 3 records from database" do
        index_friendships_response = json_response
        expect(index_friendships_response.length).to eq 3
      end

      it "returns all records its friend_id are current_user.id and state are pending" do
        index_friendships_response = json_response
        index_friendships_response.each do |index_friendship_response|
          expect(index_friendship_response[:friend_id]).to eq @current_user.id
          expect(index_friendship_response[:state]).to eq "pending"
        end
      end

      it { expect(response).to have_http_status 200 }
    end
  end

  describe "PUT/PATCH #update_friendship" do

    context "when friendship is successfully updated to accept" do
      before(:each) do
        @friendship = FactoryGirl.create :friendship, user: @user, friend_id: @current_user.id
        patch :accept_request, id: @user.id
      end

      it "renders the json presentation for the updated" do
        update_friendship_response = json_response
        expect(update_friendship_response[:friendship][:state]).to eq "accepted"
      end

      it "renders the json message" do
        update_friendship_response = json_response
        expect(update_friendship_response[:message]).to eq "已成為好友"
      end

      it { expect(response).to have_http_status 200 }
    end
  end

  describe "DELETE #decline_request" do
    before(:each) do
      @friendship = FactoryGirl.create :friendship, user: @user, friend_id: @current_user.id
      delete :decline_request, id: @user.id
    end

    it { expect(response).to have_http_status 204 }
  end

end

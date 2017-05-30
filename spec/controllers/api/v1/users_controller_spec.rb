require 'rails_helper'

RSpec.describe Api::V1::UsersController do

  before(:each) do
    request.headers['Accept'] = "application/vnd.meetdude.v1, #{Mime::JSON}"
    request.headers['Content-Type'] = Mime::JSON.to_s
  end

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eq @user.email
    end

    it { expect(response).to have_http_status 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, user: @user_attributes
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eq @user_attributes[:email]
      end

      it { expect(response).to have_http_status 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { name: "test",
                                     password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, user: @invalid_user_attributes
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { expect(response).to have_http_status 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header(@user.auth_token)
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { id: @user.id,
                         user: { email: "newmail@example.com",
                                 name: "John",
                                 password: "12345678",
                                 password_confirmation: "12345678" } }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eq "newmail@example.com"
        expect(user_response[:name]).to eq "John"
      end

      it { expect(response).to have_http_status 200}
    end

    context "when is not created" do
      before(:each) do
        patch :update, { id: @user.id,
                         user: { email: "bademail.com" } }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be updated" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { expect(response).to have_http_status 422}
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header(@user.auth_token)
      delete :destroy, { id: @user.id }
    end

    it { expect(response).to have_http_status 204 }
  end

  describe "GET #show_friendship" do
    before(:each) do
      @current_user = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @user3 = FactoryGirl.create :user
      @friendship = FactoryGirl.create :friendship, user: @current_user, friend_id: @user2.id
      api_authorization_header @current_user.auth_token
    end

    context "when current_user to user2 pages" do
      before do
        get :show_friendship, id: @user2.id
      end

      it "returns their friendship records" do
        show_friendship_response = json_response
        expect(show_friendship_response[:id]).to be_present
        expect(show_friendship_response[:friend_id]).to eq @user2.id
      end
    end

    context "when current_user to user3 pages" do
      before do
        get :show_friendship, id: @user3.id
      end

      it "returns their relationship records" do
        show_friendship_response = json_response
        expect(show_friendship_response).not_to be_present
      end
    end
  end

  describe "POST #friend_request" do
    before(:each) do
      @current_user = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user

      api_authorization_header @current_user.auth_token
    end

    context "when on the other user's page" do
      before(:each) do
        post :friend_request, { id: @user2.id }
      end
      it "renders the json records presentation for the friendship record just created" do
        friend_request_response = json_response
        expect(friend_request_response[:id]).to be_present
        expect(friend_request_response[:user_id]).to eq @current_user.id
        expect(friend_request_response[:friend_id]).to eq @user2.id
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
    before(:each) do
      @current_user = FactoryGirl.create :user
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @user3 = FactoryGirl.create :user
      @user4 = FactoryGirl.create :user
      @user5 = FactoryGirl.create :user
      api_authorization_header @current_user.auth_token
    end

    context "when current_user get all friendships which state are pending" do
      before(:each) do
        @friendship1 = FactoryGirl.create :friendship, user: @user1, friend_id: @current_user.id
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
    before(:each) do
      @current_user = FactoryGirl.create :user
      @user = FactoryGirl.create :user

      api_authorization_header @current_user.auth_token
    end

    context "when friendship is successfully updated to accept" do
      before(:each) do
        @friendship = FactoryGirl.create :friendship, user: @user, friend_id: @current_user.id
        patch :accept_request, id: @friendship.id
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
end

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
      get :index
    end

    it "returns 3 records from the database" do
      friendship_response = json_response
      expect(friendship_response.length).to eq 3
    end

    it { expect(response).to have_http_status 200 }
  end

end

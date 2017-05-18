require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      post = FactoryGirl.create :post
      4.times { FactoryGirl.create :notification, user: current_user, post: post, notice_type: "receive_post" }
      get :index, user_id: current_user.id
    end

    it "returns to 4 notifications" do
      notifications_response = json_response
      expect(notifications_response.length).to eq 4
    end

    it { expect(response).to have_http_status 200 }
  end

  describe "GET #show" do
    before(:each) do
      @current_user = FactoryGirl.create :user
      api_authorization_header @current_user.auth_token

      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user, target_id: @current_user.id
      @notification = FactoryGirl.create :notification, user: @current_user, post: @post, notified_by: @user, notice_type: "receive_post"

      get :show, { user_id: @current_user.id, id: @notification.id }
    end

    it "returns the user notification record match the id" do
      notification_response = json_response
      expect(notification_response[:id]).to eq @notification.id
    end

    it "includes the user who has the notification" do
      notification_response = json_response
      expect(notification_response[:user_id]).to eq @current_user.id
    end

    it "includes the post on the notification" do
      notification_response = json_response
      expect(notification_response[:post_id]).to eq @post.id
    end

    it "includes the user who sent the notificaion" do
      notification_response = json_response
      expect(notification_response[:notified_by_id]).to eq @user.id
    end

    it "will be have_read" do
      notification_response = json_response
      expect(notification_response[:is_read]).to eq true
    end

    it { expect(response).to have_http_status 200 }
  end

end

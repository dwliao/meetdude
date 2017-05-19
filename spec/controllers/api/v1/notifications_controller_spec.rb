require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      user = FactoryGirl.create :user
      post = FactoryGirl.create :post
      4.times { FactoryGirl.create :notification, user: current_user, post: post, notified_by: user, notice_type: "receive_post" }
      get :index, user_id: current_user.id
    end

    it "returns to 4 record from the database" do
      notifications_response = json_response
      expect(notifications_response.length).to eq 4
    end

    it "returns the user name who sent the post into each notification" do
      notifications_response = json_response
      notifications_response.each do |notification_response|
        expect(notification_response[:notified_by][:name]).to be_present
      end
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

    it "returns the user who sent notification" do
      notification_response = json_response
      expect(notification_response[:notified_by][:name]).to eq @user.name
    end

    it "includes the user who receive the notification" do
      notification_response = json_response
      expect(notification_response[:user][:email]).to eq @current_user.email
    end

    it "includes the post content on the notification" do
      notification_response = json_response
      expect(notification_response[:post][:description]).to eq @post.description
    end

    it "returns the user notification record match the id" do
      notification_response = json_response
      expect(notification_response[:id]).to eq @notification.id
    end

    it "will be have_read" do
      notification_response = json_response
      expect(notification_response[:is_read]).to eq true
    end

    it { expect(response).to have_http_status 200 }
  end

end

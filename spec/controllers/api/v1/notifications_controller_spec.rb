require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post
      4.times { FactoryGirl.create :notification, user: current_user, post: @post, notified_by: @user, notice_type: "receive_post" }
      get :index
    end

    it "returns to 4 record from the database" do
      notifications_response = json_response
      expect(notifications_response.length).to eq 4
    end

    it "returns the user name who sent the post into each notification" do
      notifications_response = json_response
      notifications_response.each do |notification_response|
        expect(notification_response[:notified_by][:name]).to eq @user.name
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

      get :show, id: @notification.id
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

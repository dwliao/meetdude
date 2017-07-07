require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post
      @limit_number = 8
      12.times { FactoryGirl.create :notification, user: current_user, post: @post, notified_by: @user, notice_type: "receive_post" }
    end

    context "when do not send params[:page]" do
      before do
        get :index
      end

      it "renders to #{@limit_number} records from the database" do
        notifications_response = json_response
        expect(notifications_response[:notifications].length).to eq @limit_number
        expect(notifications_response[:final_page_number]).to eq (12 / @limit_number)
      end

      it { expect(response).to have_http_status 200 }
    end

    context "when send params[:page] and is final page" do
      before do
        get :index, page: 1
      end

      it "renders to 4 records from the database" do
        notifications_response = json_response
        expect(notifications_response[:notifications].length).to eq (12 % @limit_number)
      end

      it "shows a message for the final page" do
        notifications_response = json_response
        expect(notifications_response[:message]).to eq "This is the final page"
      end

      it { expect(response).to have_http_status 200 }
    end
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

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

  describe "DELETE destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header(@user.auth_token)
      delete :destroy, { id: @user.id }
    end

    it { expect(response).to have_http_status 204 }
  end
end

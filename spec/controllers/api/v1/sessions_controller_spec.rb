require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #create" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do

      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eq @user.reload.auth_token
      end

      it { expect(response).to have_http_status 200}
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "wrongpassword" }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eq "Invalid email or password"
      end

      it { expect(response).to have_http_status 422 }
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, id: @user.auth_token
    end

    it { expect(response).to have_http_status 204 }
  end
end

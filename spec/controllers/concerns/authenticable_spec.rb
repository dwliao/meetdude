require 'rails_helper'

class Authentication < ActionController::Base
  include Authenticable
end

describe "Authenticable" do

  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers["Authorization"] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eq @user.auth_token
    end
  end

  describe "#authentication_with_token!" do

    controller(ApplicationController) do
      before_action :authenticate_with_token!
      def dummy_action
      end
    end

    before do
      routes.draw { get 'dummy_action' => 'anonymous#dummy_action' }
      @user = FactoryGirl.create :user
      allow(authentication).to receive(:current_user).and_return(nil)
      get :dummy_action
    end

    it "returns error message as JSON" do
      expect(json_response[:errors]).to eq "Not authenticated"
    end

    it { expect(response).to have_http_status 401 }
  end

  describe "#user_signed_in?" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context "when there is a user on 'session'" do
      before do
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it { should be_user_signed_in }
    end

    context "when there is no user on 'session'" do
      before do
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end

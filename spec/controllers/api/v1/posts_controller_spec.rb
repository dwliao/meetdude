require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  before(:each) do
    @current_user = FactoryGirl.create :user
    @user1 = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user
  end

  describe "POST #create" do
    context "when user post on his own page" do
      before(:each) do
        api_authorization_header @current_user.auth_token
        post :create, { description: "description" }
      end

      it "renders the json records presentation for the post just created" do
        post_response = json_response
        expect(post_response[:id]).to be_present
        expect(post_response[:description]).to eq "description"
        expect(post_response[:user_id]).to eq @current_user.id
        expect(post_response[:target_id]).to eq @current_user.id
      end

      it { expect(response).to have_http_status 201 }
    end

    context "when user post to others" do
      before(:each) do
        api_authorization_header @current_user.auth_token
        post :create, { description: "description", target_id: @user1.id }
      end

      it "renders the json records presentation for the post just created" do
        post_response = json_response
        expect(post_response[:id]).to be_present
        expect(post_response[:user_id]).to eq @current_user.id
        expect(post_response[:description]).to eq "description"
        expect(post_response[:target_id]).to eq @user1.id
      end

      it { expect(response).to have_http_status 201 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @post1 = FactoryGirl.create :post, user: @current_user, target_id: @user1.id
      @post2 = FactoryGirl.create :post, user: @user1, target_id: @current_user.id
      @post3 = FactoryGirl.create :post, user: @user1, target_id: @user2.id
      api_authorization_header @current_user.auth_token
    end

    context "when post is created by current_user" do
      before do
        delete :destroy, { id: @post1.id }
      end

      it { expect(response).to have_http_status 204 }
    end

    context "when post is to current_user" do
      before do
        delete :destroy, { id: @post2.id }
      end

      it { expect(response).to have_http_status 204 }
    end

    context "when post is not related with current_user" do
      before do
        delete :destroy, { id: @post3.id }
      end

      it "shows an json error message" do
        post_response = json_response
        expect(post_response[:message]).to eq "No authorization"
      end

      it { expect(response).to have_http_status 401 }
    end
  end

  describe "GET #index" do
    before(:each) do
      10.times { FactoryGirl.create :post, user: @current_user, target_id: @current_user.id }
      10.times { FactoryGirl.create :post, user: @user1, target_id: @current_user.id }
      @post1 = FactoryGirl.create :post, user: @current_user, target_id: @user1.id
      @post2 = FactoryGirl.create :post, user: @user1, target_id: @user2.id
      @post3 = FactoryGirl.create :post, user: @user2, target_id: @user1.id
    end
    context "when on current_user page" do
      before do
        api_authorization_header @current_user.auth_token
        get :index, { id: @current_user.id }
      end

      it "renders 15 records from the database" do
        posts_response = json_response
        expect(posts_response[:data].length).to eq 15
      end

      it "renders json records" do
        posts_response = json_response
        posts_response[:data].each do |post_response|
          expect(post_response[:target_id]).to eq @current_user.id
          expect(post_response[:target][:name]).to eq @current_user.name
        end
      end

      it "renders json final_page_number" do
        posts_response = json_response
        expect(posts_response[:final_page_number]).to eq 1
      end

      it "renders json message nil" do
        posts_response = json_response
        expect(posts_response[:message]).to eq nil
      end

      it { expect(response).to have_http_status 200 }
    end

    context "when current_user on his own next page" do
      before do
        api_authorization_header @current_user.auth_token
        get :index, { id: @current_user.id, page: 1 }
      end

      it "renders 5 records from the database" do
        posts_response = json_response
        expect(posts_response[:data].length).to eq 5
      end

      it "renders json message this is the final page" do
        posts_response = json_response
        expect(posts_response[:message]).to eq "This is the final page"
      end
    end

    context "when params[:page] is greater than final_page_number" do
      before do
        api_authorization_header @current_user.auth_token
        get :index, { id: @current_user.id, page: 2 }
      end

      it "renders a json message no data" do
        post_response = json_response
        expect(post_response[:message]).to eq "No data"
      end

      it { expect(response).to have_http_status 422 }
    end

    context "when on user1 page" do
      before do
        api_authorization_header @current_user.auth_token
        get :index, { id: @user1.id }
      end

      it "renders 2 records from database" do
        posts_response = json_response
        expect(json_response[:data].length).to eq 2
      end

      it "renders a json message this is the final page" do
        posts_response = json_response
        expect(json_response[:message]).to eq "This is the final page"
      end
    end
  end

end

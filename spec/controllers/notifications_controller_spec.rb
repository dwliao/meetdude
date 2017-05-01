require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  subject(:user1) { create(:user) }
  subject(:user2) { create(:user_two) }
  subject(:post2_1) { user2.posts.create(description: "2", :target => user) }
  subject(:post2_2) { user2.posts.create(description: "23", :target => user) }

  let(:notifications1) { user1.notifications }

  describe "#index" do
    before { sign_in user1 }
    before { get :index }

    it { expect(response).to have_http_status(200) }
  end
end

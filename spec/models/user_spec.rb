require "rails_helper"

RSpec.describe User, :type => :model do

  it "should be create" do
    user = User.create(
      email: 'user@mail.com',
      name: 'test',
      password: '12345678',
      password_confirmation: '12345678')

    expect(User.find_by(email: 'user@mail.com')).to eq(user)
    expect(User.find_by(name: 'test')).to eq(user)
    expect(user.valid_password?('12345678')).to be_truthy
    expect(user.valid_password?('1234')).to be_falsey
    expect(User.all.length).to eq(1)
  end

  it "shouldn't be create if password and password_confirmation are not the same" do
    user = User.create(
      email: 'user@mail.com',
      name: 'test',
      password: '12345678',
      password_confirmation: '1234')

    expect(User.all.length).to eq(0)
  end

  it "shouldn't be create if name is empty or null" do
    user1 = User.create(
      email: 'user1@mail.com',
      name: '',
      password: '12345678',
      password_confirmation: '12345678')

    user2 = User.create(
      email: 'user2@mail.com',
      password: '12345678',
      password_confirmation: '12345678')

    expect(User.all.length).to eq(0)
  end

  it "can create post" do
    user = User.create(
      email: 'user@mail.com',
      name: 'test',
      password: '12345678',
      password_confirmation: '12345678')
    post = user.posts.create(
      description: 'description')

    expect(user.posts).to include(post)
    expect(post.user).to eq(user)
  end

  it "can post to others" do
    user1 = User.create(
      email: 'user1@mail.com',
      name: 'test1',
      password: '12345678',
      password_confirmation: '12345678')
    user2 = User.create(
      email: 'user2@mail.com',
      name: 'test2',
      password: '12345678',
      password_confirmation: '12345678')
    post1 = user1.posts.create(
      description: 'description1',
      target_id: user2.id)
    post2 = user2.posts.create(
      description: 'description2',
      target_id: user1.id)
    post3 = user1.posts.create(
      description: 'description3')

    expect(user1.posts).to include(post1)
    expect(user2.target_posts).to include(post1)
    expect(user2.target_posts).not_to include(post2)
    expect(Post.where(target_id: user1.id).length).to eq(2)
    expect(Post.where(target_id: user2.id).length).to eq(1)
    expect(Post.where(user_id: user1.id).length).to eq(2)
    expect(Post.where(user_id: user2.id).length).to eq(1)
    expect(post1.target).to eq(user2)
    expect(post1.target).not_to eq(user1)
    expect(post2.target).to eq(user1)
    expect(post2.target).not_to eq(user2)
    expect(post3.target).to eq(user1)
    expect(post3.target).not_to eq(user2)
  end

  it { should respond_to(:auth_token) }

  describe "#generate_authentication_token!" do

    before { @user = FactoryGirl.create :user }
    subject { @user }

    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("uniquetoken")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eq "uniquetoken"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "uniquetoken")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eq existing_user.auth_token
    end
  end
end

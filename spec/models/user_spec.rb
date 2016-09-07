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
      title: 'title',
      description: 'description')

    expect(user.posts).to include(post)
    expect(post.user).to eq(user)
  end
end

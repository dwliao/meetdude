require "rails_helper"

RSpec.describe User, :type => :model do
  it "can create user" do
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

  it "cannot create user if password and password_confirmation not the same" do
    user = User.create(
      email: 'user@mail.com',
      name: 'test',
      password: '12345678',
      password_confirmation: '1234')

    expect(User.all.length).to eq(0)
  end

  it "cannot create user if name is empty or null" do
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
end
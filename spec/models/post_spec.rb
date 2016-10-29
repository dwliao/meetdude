require 'rails_helper'

RSpec.describe Post, type: :model do
  it "should be created" do
    post = Post.create!(:title => "title",
                        :user_id => "11",
                        :description => "description",
                        :target_id => "12")
    expect(Post.find_by(target_id: 12)).to eq(post)
    expect(post.target_id).not_to eq(post.user_id)
    expect(Post.find_by(target_id: nil)).not_to eq(post)
  end

  it "should be created without target_id" do
    post = Post.create!(
      user_id: '10',
      title: 'title',
      description: 'description')
    expect(Post.find_by(description: 'description')).to eq(post)
    expect(Post.find_by(description: 'no')).not_to eq(post)
    expect(post.target_id).to eq(post.user_id)
    expect(Post.where(target_id: nil).length).to eq(0)
  end

  it "has user_id, description and target_id columns" do
    columns = Post.column_names
    # => ["id", "user_id", "description", "target_id"]
    expect(columns).to include("id")
    expect(columns).not_to include("happy_id")
    expect(columns).to include("user_id")
    expect(columns).to include("description")
    expect(columns).to include("target_id")
    # expect(columns).not_to include("") 反面寫法
  end

  it ".no_description" do
    post_with_description = Post.create(:user_id => "1", :description => "description")
    post_without_description = Post.create(:user_id => "1", :description => nil)
    expect(Post.no_description).to include post_without_description
    expect(Post.no_description).not_to include post_with_description
  end
end

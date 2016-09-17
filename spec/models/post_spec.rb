require 'rails_helper'

RSpec.describe Post, type: :model do
  it "should be created" do
    post = Post.create(
      title: 'title',
      description: 'description')

    expect(Post.find_by(title: 'title')).to eq(post)
    expect(Post.find_by(description: 'description')).to eq(post)
  end

  it "is accessible" do
    post = Post.create!(:title => "title")
    expect(post).to eq(Post.last)
  end

  it "has title and content columns" do
    columns = Post.column_names
    # => ["id", "title", "description"]
    expect(columns).to include("id")
    expect(columns).to include("title")
    expect(columns).to include("description")
    # expect(columns).not_to include("") 反面寫法
  end

  it ".no_description" do
    post_with_description = Post.create(:title => "title", :description => "description")
    post_without_description = Post.create(:title => "title", :description => nil)
    expect(Post.no_description).to include post_without_description
    expect(Post.no_description).not_to include post_with_description
  end
end

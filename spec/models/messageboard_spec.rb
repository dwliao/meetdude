require 'rails_helper'

RSpec.describe Messageboard, type: :model do
  #it "should be created" do
  #  messageboard = Messageboard.create(
  #  title: 'test',
  #  description: 'test'
  #  )

  #  expect(Messageboard.find_by(title: 'test')).to eq(messageboard)
  #  expect(Messageboard.find_by(description: 'test')).to eq(messageboard)
  #  expect()
  #end

  it "is accessible" do
    messageboard = Messageboard.create!(:title => "title")
    expect(messageboard).to eq(Messageboard.last)
  end

  it "has title and content columns" do
    columns = Messageboard.column_names
    # => ["id", "title", "description"]
    expect(columns).to include("id")
    expect(columns).to include("title")
    expect(columns).to include("description")
    # expect(columns).not_to include("") 反面寫法
  end

  it "validates title" do
    expect(Messageboard.new).not_to be_valid
    expect(Messageboard.new(:title => "title")).to be_valid
  end

  it ".no_description" do
    messageboard_with_description = Messageboard.create(:title => "title", :description => "description")
    messageboard_without_description = Messageboard.create(:title => "title", :description => nil)
    expect(Messageboard.no_description).to include messageboard_without_description
    expect(Messageboard.no_description).not_to include messageboard_with_description
  end

end

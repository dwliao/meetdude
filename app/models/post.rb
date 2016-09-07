class Post < ActiveRecord::Base
  validates :title, presence: true

  def self.no_description
    where(:description => nil)
  end

  belongs_to :user
end

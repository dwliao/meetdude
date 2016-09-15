class Post < ActiveRecord::Base

  def self.no_description
    where(:description => nil)
  end

  belongs_to :user
end

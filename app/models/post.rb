class Post < ActiveRecord::Base
  validates :title, presence: true

  def self.no_description
    where(:description => nil)
  end

  belongs_to :owner, class_name: "User", foreign_key: :user_id
end

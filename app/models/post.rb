class Post < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :target, class_name: "User", foreign_key: "target_id"

  def self.no_description
    where(:description => nil)
  end
end

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: "friend_id"

  def accepted_friend!
    self.update!(state: "accepted")
  end
end

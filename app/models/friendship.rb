class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: "friend_id"
  validates :user_id, presence: true
  validates :friend_id, presence: true

  def accepte_friend!
    self.update!(state: "accepted")
  end
end

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: "friend_id"
  validates :user_id, presence: true
  validates :friend_id, presence: true

  scope :pending, -> { where(state: "pending") }

  def be_friend!
    self.update!(state: "accepted")
  end
end

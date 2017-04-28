class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :notice_target, class_name: "User", foreign_key: "target_id"

  scope :notice_post,           -> { where(notice_type: "receive_post") }
  scope :notice_friend_request, -> { where(notice_type: "receive_friend") }

  def read?
    is_read
  end
  
end

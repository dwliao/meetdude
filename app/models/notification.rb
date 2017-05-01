class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :notified_by, class_name: "User", foreign_key: "notified_by_id"

  scope :notify_post,           -> { where(notice_type: "receive_post") }
  scope :notify_friend_request, -> { where(notice_type: "receive_friend") }

  def read?
    is_read
  end

  def have_read
    self.update_columns(is_read: true)
  end

end

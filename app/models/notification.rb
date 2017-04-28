class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :notice_target, class_name: "User", foreign_key: "target_id"
end

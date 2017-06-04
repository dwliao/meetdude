class Post < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :target, class_name: "User", foreign_key: "target_id"

  before_save :check_target_id!
  after_save :generate_notification!

  has_many :notifications, dependent: :destroy

  scope :recent, -> { order("updated_at DESC") }

  def self.which_related_to(user_id, search_type, start_search_time, is_forward, limit_number)
    time = start_search_time.nil? ? Time.now : Time.at(start_search_time.to_i)
    if !user_id.nil? && !user_id.empty?
      case search_type
        when "TO"
          if is_forward == "true"
            if limit_number
              where("target_id = ? and updated_at > ?", user_id, time).recent.limit(limit_number)
            else
              where("target_id = ? and updated_at > ?", user_id, time).recent
            end
          else
            if limit_number
              where("target_id = ? and updated_at < ?", user_id, time).recent.limit(limit_number)
            else
              where("target_id = ? and updated_at < ?", user_id, time).recent
            end
          end
        when "FROM"
          if is_forward == "true"
            if limit_number
              where("user_id = ? and updated_at > ?", user_id, time).recent.limit(limit_number)
            else
              where("user_id = ? and updated_at > ?", user_id, time).recent
            end
          else
            if limit_number
              where("user_id = ? and updated_at < ?", user_id, time).recent.limit(limit_number)
            else
              where("user_id = ? and updated_at < ?", user_id, time).recent
            end
          end
        else
      end
    end
  end

  def self.no_description
    where(:description => nil)
  end

  protected

  def check_target_id!
    if !self.target_id
      self.target_id = self.user_id
    end
  end

  def generate_notification!
    return if self.target.id == self.user.id
    Notification.create(user_id: self.target.id,
                        notified_by_id: self.user.id,
                        post_id: self.id,
                        notice_type: "receive_post")
  end

end

class Post < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :target, class_name: "User", foreign_key: "target_id"
  before_save :check_target_id!

  scope :recent, -> { order(updated_at: :DESC) }

  def self.which_related_to (user_id, search_type, start_search_time, is_forward, limit_number)
    time = Time.at(start_search_time.to_i)
    if search_type == 'To'
      if start_search_time
        if is_forward
          where(['target_id = :id and updated_at > :time', { id: user_id, time: time }]).limit(limit_number).recent
        else
          where(['target_id = :id and updated_at <= :time', { id: user_id, time: time }]).limit(limit_number).recent
        end
      elsif search_type == 'From'
        if is_forward
          where(['user_id = :id and updated_at > :time', { id: user_id, time: time }]).limit(limit_number).recent
        else
          where(['user_id = :id and updated_at <= :time', { id: user_id, time: time }]).limit(limit_number).recent
        end
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
end

class Post < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :target, class_name: "User", foreign_key: "target_id"
  before_save :check_target_id!

  scope :recent, -> { order(updated_at: :DESC) }
  scope :target_updated, -> (id, time) { where(['target_id = :id and updated_at > :time', {id: id, time: time}]) }
  #scope :target_update, -> (time) {where('updated_at > ?', time)}
  #scope :target_updated, -> (time) {where('updated_at < ?', time)}

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

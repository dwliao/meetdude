class ChangeNotificationColumnTargetToNotificedBy < ActiveRecord::Migration
  def change
    rename_column :notifications, :target_id, :notified_by_id
  end
end

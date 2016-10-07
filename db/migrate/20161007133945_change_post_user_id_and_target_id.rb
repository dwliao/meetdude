class ChangePostUserIdAndTargetId < ActiveRecord::Migration
  def change
    change_column :posts, :user_id, :integer, :null => false
    change_column :posts, :target_id, :integer, :null => false
  end
end

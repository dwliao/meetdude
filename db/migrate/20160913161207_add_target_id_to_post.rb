class AddTargetIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :target_id, :integer
  end
end

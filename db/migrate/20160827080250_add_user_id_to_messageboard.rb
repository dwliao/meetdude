class AddUserIdToMessageboard < ActiveRecord::Migration
  def change
    add_column :messageboards, :user_id, :integer
  end
end

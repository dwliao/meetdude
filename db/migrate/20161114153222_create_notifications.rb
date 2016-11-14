class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :type
      t.integer :user_id
      t.integer :target_id
      t.boolean :is_read, default: false

      t.timestamps null: false
    end
  end
end

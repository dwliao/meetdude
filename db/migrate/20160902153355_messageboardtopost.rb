class Messageboardtopost < ActiveRecord::Migration
  def change
    rename_table :messageboards, :post
  end
end

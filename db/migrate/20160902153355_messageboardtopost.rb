class Messageboardtopost < ActiveRecord::Migration
  def change
    rename_table :messageboards, :posts;
  end
end

#messageboards_to_post"s"

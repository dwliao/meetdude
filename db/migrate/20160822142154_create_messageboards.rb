class CreateMessageboards < ActiveRecord::Migration
  def change
    create_table :messageboards do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end

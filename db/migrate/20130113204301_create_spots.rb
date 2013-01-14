class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.integer :user_id
      t.integer :restaurant_id

      t.timestamps
    end

    add_index :spots, :user_id
    add_index :spots, :restaurant_id
    add_index :spots, [:user_id, :restaurant_id], unique: true
  end
end

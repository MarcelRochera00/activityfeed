class CreateHikes < ActiveRecord::Migration[8.1]
  def change
    create_table :hikes do |t|
      t.decimal :distance_km
      t.string :duration
      t.integer :elevation_gain
      t.string :trail_name

      t.timestamps
    end
  end
end

class CreateConcerts < ActiveRecord::Migration[8.1]
  def change
    create_table :concerts do |t|
      t.string :artist
      t.string :venue
      t.date :date
      t.text :tracklist
      t.timestamps
    end
  end
end

class CreateReadings < ActiveRecord::Migration[8.1]
  def change
    create_table :readings do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.timestamps
    end
  end
end

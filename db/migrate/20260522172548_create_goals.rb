class CreateGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.decimal :target_value
      t.decimal :current_value
      t.string :unit
      t.string :activity_type
      t.integer :status
      t.datetime :completed_at

      t.timestamps
    end
  end
end

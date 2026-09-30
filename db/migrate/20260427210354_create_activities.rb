class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.integer :status, default: 0, null: false
      t.string :slug
      t.datetime :published_at
      t.integer :likes_count, default: 0, null: false
      t.integer :views_count, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :activities, :slug, unique: true
    add_index :activities, :title, unique: true
  end
end

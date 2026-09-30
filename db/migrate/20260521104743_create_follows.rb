class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end

    # Ensure we can find follows quickly
    add_index :follows, :follower_id
    add_index :follows, :followed_id

    # 💡 Question for the Database:
    # Can a user follow the same person twice?
    # This index ensures the answer is NO at the database level.
    add_index :follows, [ :follower_id, :followed_id ], unique: true

    # Add foreign keys (pointing to the users table)
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id
  end
end

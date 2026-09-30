class AddFollowsCountersToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :followers_count, :integer, default: 0, null: false
    add_column :users, :followings_count, :integer, default: 0, null: false

    # Backfill existing counts
    up_only do
      User.find_each do |user|
        User.reset_counters(user.id, :passive_relationships)
        User.reset_counters(user.id, :active_relationships)
      end
    end
  end
end

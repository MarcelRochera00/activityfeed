class AddCommentsCountToActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :activities, :comments_count, :integer, default: 0, null: false

    # Professional touch: Update existing records so they have the correct count immediately.
    # We do this in the migration so the database is "accurate" the moment it's migrated.
    up_only do
      Activity.reset_column_information
      Activity.find_each do |activity|
        Activity.reset_counters(activity.id, :comments)
      end
    end
  end
end

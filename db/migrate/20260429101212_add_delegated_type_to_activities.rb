class AddDelegatedTypeToActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :activities, :activityable_type, :string
    add_column :activities, :activityable_id, :integer
    add_index :activities, [ :activityable_type, :activityable_id ]
  end
end

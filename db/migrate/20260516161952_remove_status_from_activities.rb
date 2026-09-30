class RemoveStatusFromActivities < ActiveRecord::Migration[8.1]
  def change
    remove_column :activities, :status, :integer
  end
end

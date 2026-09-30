class ChangeGoalsDefaults < ActiveRecord::Migration[8.1]
  def change
    change_column_default :goals, :current_value, 0
    change_column_null :goals, :current_value, false

    change_column_default :goals, :status, 0
    change_column_null :goals, :status, false

    change_column_null :goals, :description, false
    change_column_null :goals, :target_value, false
    change_column_null :goals, :unit, false
    change_column_null :goals, :activity_type, false
  end
end

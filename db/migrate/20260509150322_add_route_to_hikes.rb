class AddRouteToHikes < ActiveRecord::Migration[8.1]
  def change
    add_column :hikes, :route, :text
  end
end

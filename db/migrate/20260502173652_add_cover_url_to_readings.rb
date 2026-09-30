class AddCoverUrlToReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :readings, :cover_url, :string
  end
end

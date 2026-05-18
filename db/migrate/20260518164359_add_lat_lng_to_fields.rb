class AddLatLngToFields < ActiveRecord::Migration[8.1]
  def change
    add_column :fields, :latitude, :decimal
    add_column :fields, :longitude, :decimal
  end
end

class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :vc_identifier, null: false

      t.timestamps
    end

    add_index :locations, :name, unique: true
    add_index :locations, :vc_identifier, unique: true
  end
end

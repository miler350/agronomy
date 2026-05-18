class CreatePlantingEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :planting_events do |t|
      t.references :field, null: false, foreign_key: true
      t.date :planted_on
      t.string :product

      t.timestamps
    end
  end
end

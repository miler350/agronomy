class CreateFieldObservations < ActiveRecord::Migration[8.1]
  def change
    create_table :field_observations do |t|
      t.references :planting_event, null: false, foreign_key: true
      t.references :growth_stage, null: false, foreign_key: true
      t.date :observed_on
      t.decimal :observed_gdd
      t.text :notes

      t.timestamps
    end
  end
end

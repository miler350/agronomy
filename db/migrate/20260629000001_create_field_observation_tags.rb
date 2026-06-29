class CreateFieldObservationTags < ActiveRecord::Migration[8.0]
  def change
    create_table :field_observation_tags do |t|
      t.references :field_observation, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :field_observation_tags, [:field_observation_id, :tag_id], unique: true
  end
end

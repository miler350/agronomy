class CreateTagsAndFieldTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true

    create_table :field_tags do |t|
      t.references :field, null: false, foreign_key: true
      t.references :tag,   null: false, foreign_key: true
      t.timestamps
    end
    add_index :field_tags, [:field_id, :tag_id], unique: true
  end
end

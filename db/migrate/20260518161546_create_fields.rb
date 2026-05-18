class CreateFields < ActiveRecord::Migration[8.1]
  def change
    create_table :fields do |t|
      t.string :name
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end

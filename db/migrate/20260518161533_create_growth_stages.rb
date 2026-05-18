class CreateGrowthStages < ActiveRecord::Migration[8.1]
  def change
    create_table :growth_stages do |t|
      t.string :name
      t.decimal :gdd_threshold
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end

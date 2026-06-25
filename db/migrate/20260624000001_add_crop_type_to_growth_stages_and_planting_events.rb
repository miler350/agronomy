class AddCropTypeToGrowthStagesAndPlantingEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :growth_stages, :crop_type, :string, default: "corn", null: false
    add_column :planting_events, :crop_type, :string, default: "corn", null: false
  end
end

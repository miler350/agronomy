class AddFarmToFields < ActiveRecord::Migration[8.1]
  def change
    add_column :fields, :farm, :string

    geojson_path = Rails.root.join("public", "fields.geojson")
    return unless File.exist?(geojson_path)

    data = JSON.parse(File.read(geojson_path))
    data["features"].each do |feature|
      name = feature.dig("properties", "field_id")
      farm = feature.dig("properties", "farm")
      next unless name && farm
      Field.find_by(name: name)&.update_column(:farm, farm)
    end
  end
end

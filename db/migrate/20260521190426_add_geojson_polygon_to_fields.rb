class AddGeojsonPolygonToFields < ActiveRecord::Migration[8.1]
  def change
    add_column :fields, :geojson_polygon, :text

    geojson_path = Rails.root.join("public", "fields.geojson")
    return unless File.exist?(geojson_path)

    data = JSON.parse(File.read(geojson_path))
    data["features"].each do |feature|
      name = feature.dig("properties", "field_id")
      next unless name
      field = Field.find_by(name: name)
      field&.update_column(:geojson_polygon, feature["geometry"].to_json)
    end
  end
end

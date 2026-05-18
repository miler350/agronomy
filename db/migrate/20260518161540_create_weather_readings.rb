class CreateWeatherReadings < ActiveRecord::Migration[8.1]
  def change
    create_table :weather_readings do |t|
      t.references :location, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :max_temperature
      t.decimal :min_temperature
      t.decimal :temperature
      t.decimal :feels_like_max
      t.decimal :feels_like_min
      t.decimal :feels_like
      t.decimal :dew
      t.decimal :humidity
      t.decimal :precip
      t.decimal :precip_prob
      t.decimal :precip_cover
      t.string :precip_type
      t.decimal :snow
      t.decimal :snow_depth
      t.decimal :wind_gust
      t.decimal :wind_speed
      t.decimal :wind_dir
      t.decimal :sea_level_pressure
      t.decimal :cloud_cover
      t.decimal :visibility
      t.decimal :solar_radiation
      t.decimal :solar_energy
      t.integer :uv_index
      t.integer :severe_risk
      t.string :sunrise
      t.string :sunset
      t.decimal :moon_phase
      t.string :conditions
      t.text :description
      t.string :icon
      t.string :stations

      t.timestamps
    end

    add_index :weather_readings, [ :location_id, :date ], unique: true
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_24_000003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "field_observations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "growth_stage_id", null: false
    t.text "notes"
    t.decimal "observed_gdd"
    t.date "observed_on"
    t.bigint "planting_event_id", null: false
    t.datetime "updated_at", null: false
    t.index ["growth_stage_id"], name: "index_field_observations_on_growth_stage_id"
    t.index ["planting_event_id"], name: "index_field_observations_on_planting_event_id"
  end

  create_table "field_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "field_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id", "tag_id"], name: "index_field_tags_on_field_id_and_tag_id", unique: true
    t.index ["field_id"], name: "index_field_tags_on_field_id"
    t.index ["tag_id"], name: "index_field_tags_on_tag_id"
  end

  create_table "fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "farm"
    t.text "geojson_polygon"
    t.decimal "latitude"
    t.bigint "location_id", null: false
    t.decimal "longitude"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_fields_on_location_id"
  end

  create_table "growth_stages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crop_type", default: "corn", null: false
    t.text "description"
    t.decimal "gdd_threshold"
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "vc_identifier", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
    t.index ["vc_identifier"], name: "index_locations_on_vc_identifier", unique: true
  end

  create_table "planting_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crop_type", default: "corn", null: false
    t.bigint "field_id", null: false
    t.date "planted_on"
    t.string "product"
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_planting_events_on_field_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weather_readings", force: :cascade do |t|
    t.decimal "cloud_cover"
    t.string "conditions"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.text "description"
    t.decimal "dew"
    t.decimal "feels_like"
    t.decimal "feels_like_max"
    t.decimal "feels_like_min"
    t.decimal "humidity"
    t.string "icon"
    t.bigint "location_id", null: false
    t.decimal "max_temperature"
    t.decimal "min_temperature"
    t.decimal "moon_phase"
    t.decimal "precip"
    t.decimal "precip_cover"
    t.decimal "precip_prob"
    t.string "precip_type"
    t.decimal "sea_level_pressure"
    t.integer "severe_risk"
    t.decimal "snow"
    t.decimal "snow_depth"
    t.decimal "solar_energy"
    t.decimal "solar_radiation"
    t.string "stations"
    t.string "sunrise"
    t.string "sunset"
    t.decimal "temperature"
    t.datetime "updated_at", null: false
    t.integer "uv_index"
    t.decimal "visibility"
    t.decimal "wind_dir"
    t.decimal "wind_gust"
    t.decimal "wind_speed"
    t.index ["location_id", "date"], name: "index_weather_readings_on_location_id_and_date", unique: true
    t.index ["location_id"], name: "index_weather_readings_on_location_id"
  end

  add_foreign_key "field_observations", "growth_stages"
  add_foreign_key "field_observations", "planting_events"
  add_foreign_key "field_tags", "fields"
  add_foreign_key "field_tags", "tags"
  add_foreign_key "fields", "locations"
  add_foreign_key "planting_events", "fields"
  add_foreign_key "weather_readings", "locations"
end

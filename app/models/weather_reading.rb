class WeatherReading < ApplicationRecord
  belongs_to :location

  validates :date, presence: true, uniqueness: { scope: :location_id }
  validates :max_temperature, :min_temperature, presence: true
end

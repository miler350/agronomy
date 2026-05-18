class Location < ApplicationRecord
  has_many :weather_readings, dependent: :destroy
  has_many :fields, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :vc_identifier, presence: true, uniqueness: true
end

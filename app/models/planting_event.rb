class PlantingEvent < ApplicationRecord
  belongs_to :field
  has_many :field_observations, dependent: :destroy

  validates :planted_on, presence: true
  validates :product, presence: true
  validates :crop_type, inclusion: { in: %w[corn soybean] }
end

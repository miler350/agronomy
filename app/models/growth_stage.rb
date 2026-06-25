class GrowthStage < ApplicationRecord
  has_many :field_observations, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :crop_type }
  validates :position, presence: true, uniqueness: { scope: :crop_type }

  default_scope { order(:position) }
end

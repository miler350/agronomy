class GrowthStage < ApplicationRecord
  has_many :field_observations, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :position, presence: true, uniqueness: true

  default_scope { order(:position) }
end

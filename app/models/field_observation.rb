class FieldObservation < ApplicationRecord
  belongs_to :planting_event
  belongs_to :growth_stage
  has_many :field_observation_tags, dependent: :destroy
  has_many :tags, through: :field_observation_tags

  validates :observed_on, presence: true
  validates :observed_gdd, presence: true
end

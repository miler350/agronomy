class FieldObservation < ApplicationRecord
  belongs_to :planting_event
  belongs_to :growth_stage

  validates :observed_on, presence: true
  validates :observed_gdd, presence: true
end

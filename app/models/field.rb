class Field < ApplicationRecord
  belongs_to :location
  has_many :planting_events, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

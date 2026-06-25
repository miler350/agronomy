class Field < ApplicationRecord
  belongs_to :location
  has_many :planting_events, dependent: :destroy
  has_many :field_tags, dependent: :destroy
  has_many :tags, through: :field_tags

  validates :name, presence: true, uniqueness: true
end

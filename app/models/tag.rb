class Tag < ApplicationRecord
  has_many :field_tags, dependent: :destroy
  has_many :fields, through: :field_tags
  has_many :field_observation_tags, dependent: :destroy
  has_many :field_observations, through: :field_observation_tags
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

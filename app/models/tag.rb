class Tag < ApplicationRecord
  has_many :field_tags, dependent: :destroy
  has_many :fields, through: :field_tags
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

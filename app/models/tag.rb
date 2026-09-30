class Tag < ApplicationRecord
  has_many :activity_tags, dependent: :destroy
  has_many :activities, through: :activity_tags

  validates :name, presence: true, uniqueness: true
end

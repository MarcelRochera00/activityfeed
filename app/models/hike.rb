class Hike < ApplicationRecord
  has_one :activity, as: :activityable, dependent: :destroy
  accepts_nested_attributes_for :activity

  serialize :route, coder: JSON

  delegate :title, :slug, :user, :tags, :likes, :comments, :published_at, to: :activity, allow_nil: true
end

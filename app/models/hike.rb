class Hike < ApplicationRecord
  has_one :activity, as: :activityable, dependent: :destroy
  accepts_nested_attributes_for :activity

  serialize :route, coder: JSON

  delegate :title, :slug, :user, :tags, :likes, :comments, :published_at, to: :activity, allow_nil: true

  after_update_commit :touch_activity # this way activity gets updated and can sync with the goals

  private

  def touch_activity
    activity&.touch
  end
end

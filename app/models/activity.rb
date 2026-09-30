class Activity < ApplicationRecord
  belongs_to :user

  delegated_type :activityable, types: %w[Concert Reading Hike Restaurant Artwork Recipe Other], dependent: :destroy

  has_one_attached :preview_image
  has_rich_text :body

  has_many :activity_tags, dependent: :destroy
  has_many :tags, through: :activity_tags

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  extend FriendlyId
  friendly_id :title, use: [ :slugged, :history, :finders ]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

  before_create -> { self.published_at ||= Time.current }

  def liked_by?(user)
    return false unless user
    likes.any? { |like| like.user_id == user.id }
  end

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  after_commit :sync_user_goals

  scope :search, ->(query) {
    return all if query.blank?

    if query.start_with?("#")
      tag_name = query[1..].downcase
      joins(:tags).where("LOWER(tags.name) LIKE ?", "%#{tag_name}%").distinct
    else
      where("LOWER(title) LIKE ?", "%#{query.downcase}%")
    end
  }

  def self.trending_tags(limit = 8)
    Tag.joins(:activity_tags)
       .group("tags.id")
       .order("COUNT(activity_tags.id) DESC")
       .limit(limit)
  end

  def specific_path(**options)
    Rails.application.routes.url_helpers.send("#{activityable_type.underscore}_path", self, **options)
  end

  def specific_edit_path(**options)
    Rails.application.routes.url_helpers.send("edit_#{activityable_type.underscore}_path", self, **options)
  end

  private

  def sync_user_goals
    # Find all goals for this user that track this specific activity type
    user.goals.where(activity_type: activityable_type).find_each(&:sync_with_activities)
  end
end

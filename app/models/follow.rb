class Follow < ApplicationRecord
  # The person who is following
  belongs_to :follower, class_name: "User", counter_cache: :followings_count

  # The person being followed
  belongs_to :followed, class_name: "User", counter_cache: :followers_count

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validate :cannot_follow_self

  private

  def cannot_follow_self
    if follower_id == followed_id
      errors.add(:follower_id, "can't follow yourself")
    end
  end
end

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :activity, counter_cache: true

  validates :user_id, uniqueness: { scope: :activity_id }
end

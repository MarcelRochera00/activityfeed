class ActivityTag < ApplicationRecord
  belongs_to :activity
  belongs_to :tag

  validates :activity_id, uniqueness: { scope: :tag_id }
end

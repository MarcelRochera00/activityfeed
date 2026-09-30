class Goal < ApplicationRecord
  belongs_to :user

  enum :status, { active: 0, completed: 1 }, default: :active

  validates :description, presence: true
  validates :target_value, presence: true, numericality: { greater_than: 0 }
  validates :current_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :unit, presence: true
  validates :activity_type, presence: true, inclusion: { in: %w[Concert Reading Hike Other Restaurant Artwork Recipe] }

  after_initialize :set_defaults, if: :new_record?
  before_save :check_completion

  def progress_percentage
    return 100 if completed?
    return 0 if target_value.zero?
    [ (current_value.to_f / target_value.to_f * 100).round, 100 ].min
  end

  def formatted_current
    unit.downcase == "count" ? current_value.to_i : current_value
  end

  def formatted_target
    unit.downcase == "count" ? target_value.to_i : target_value
  end

  # The "Magic" recalculation logic
  def sync_with_activities
    activities = user.activities.where(activityable_type: activity_type)

    new_value = if unit.downcase == "count" || unit.downcase == "activities"
      activities.count
    elsif unit.downcase == "km" && activity_type == "Hike"
      activities.joins("INNER JOIN hikes ON activities.activityable_id = hikes.id AND activities.activityable_type = 'Hike'")
                .sum("hikes.distance_km")
    else
      activities.count
    end

    update(current_value: new_value)
  end

  private

  def set_defaults
    self.current_value ||= 0.0
  end

  def check_completion
    if current_value >= target_value && active?
      self.status = :completed
      self.completed_at = Time.current
    elsif current_value < target_value && completed?
      self.status = :active
      self.completed_at = nil
    end
  end
end

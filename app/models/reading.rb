class Reading < ApplicationRecord
  has_one :activity, as: :activityable, dependent: :destroy
  accepts_nested_attributes_for :activity
end

class Concert < ApplicationRecord
  has_one :activity, as: :activityable, dependent: :destroy
  accepts_nested_attributes_for :activity

  serialize :tracklist, type: Array, coder: JSON

  def tracklist=(value)
    if value.is_a?(String)
      begin
        super(JSON.parse(value))
      rescue JSON::ParserError
        super([])
      end
    else
      super(value)
    end
  end
end

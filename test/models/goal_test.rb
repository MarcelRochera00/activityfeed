require "test_helper"

class GoalTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @activity = activities(:one)
  end

  test "does not count activities published before the goal was created" do
    goal = Goal.create!(user: @user, description: "Goal number one", target_value: 3, unit: "count", activity_type: "Other")

    other = Other.create!(
      activity_attributes: {
        title: "Activity other",
        body: "example",
        user: @user
      }
    )

    goal.reload

    assert_equal 1, goal.current_value
  end
end

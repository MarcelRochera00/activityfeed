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

  test "recalculates km count when modifying a hike that was counted" do
    goal = Goal.create!(user: @user, description: "Goal hike one", target_value: 30, unit: "km", activity_type: "Hike")

    hike = Hike.create!(
      trail_name: "Nature Walk",
      distance_km: 20,
      activity_attributes: {
        title: "Cool Morning Hike",
        body: "Fresh air!",
        user: @user
      }
    )

    goal.reload

    assert_equal 20, goal.current_value

    hike.update!(distance_km: 10)

    goal.reload

    assert_equal 10, goal.current_value
  end
end

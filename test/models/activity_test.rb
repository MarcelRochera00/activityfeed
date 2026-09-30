require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @tag_fiction = tags(:one) # TagOne
    @tag_nature = tags(:two)  # TagTwo

    # Create some test data
    @hike = Hike.create!(
      trail_name: "Nature Walk",
      activity_attributes: {
        title: "Lovely Morning Hike",
        body: "Fresh air!",
        user: @user,
        tag_ids: [ @tag_nature.id ]
      }
    )

    @reading = Reading.create!(
      title: "Science Fiction Book",
      author: "Isaac Asimov",
      activity_attributes: {
        title: "Reading Asimov",
        body: "Classic sci-fi.",
        user: @user,
        tag_ids: [ @tag_fiction.id ]
      }
    )
  end

  test "search finds activity by title" do
    results = Activity.search("Morning")
    assert_includes results, @hike.activity
    assert_not_includes results, @reading.activity
  end

  test "search finds activity by tag using #" do
    results = Activity.search("##{@tag_nature.name}")
    assert_includes results, @hike.activity
    assert_not_includes results, @reading.activity
  end

  test "search returns all if query is blank" do
    assert_equal Activity.count, Activity.search("").count
  end

  test "should not save activity without title" do
    activity = Activity.new(user: @user)
    assert_not activity.save
  end

  test "should have unique title" do
    duplicate = Activity.new(title: "Reading Asimov", user: @user)
    assert_not duplicate.save
  end

  test "comments_count counter cache increments and decrements" do
    activity = @hike.activity
    assert_equal 0, activity.comments_count

    assert_difference "activity.reload.comments_count", 1 do
      activity.comments.create!(user: @user, body: "Great hike!")
    end

    assert_difference "activity.reload.comments_count", -1 do
      activity.comments.first.destroy
    end
  end
end

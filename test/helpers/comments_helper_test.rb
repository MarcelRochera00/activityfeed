require "test_helper"

class CommentsHelperTest < ActionView::TestCase
  include CommentsHelper

  test "should return 'Today' for today's date" do
    # Freeze time to ensure test consistency
    current_time = Time.zone.parse("2026-05-18 12:00:00")
    travel_to current_time do
      comment_time = Time.zone.parse("2026-05-18 09:30:00")
      assert_equal "Today", format_comment_date(comment_time)
    end
  end

  test "should return 'day/month' (european) for other dates in the same year" do
    current_time = Time.zone.parse("2026-05-18 12:00:00")
    travel_to current_time do
      comment_time = Time.zone.parse("2026-04-12 15:45:00")
      assert_equal "12/04", format_comment_date(comment_time)
    end
  end

  test "should return 'day/month/year' (european) for dates in different years" do
    current_time = Time.zone.parse("2026-05-18 12:00:00")
    travel_to current_time do
      comment_time = Time.zone.parse("2025-10-05 08:15:00")
      assert_equal "05/10/2025", format_comment_date(comment_time)
    end
  end
end

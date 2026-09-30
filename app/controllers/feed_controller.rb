class FeedController < ApplicationController
  def index
    @is_home = true
    @activities = Activity.preload(:user, :tags, :likes, :activityable, :rich_text_body, :comments)
                          .with_attached_preview_image
                          .where.not(user: current_user)
                          .order(published_at: :desc)

    @activities = @activities.search(params[:q]) if params[:q].present?

    @user_activities_count = current_user.activities.count
    @user_total_likes = current_user.activities.sum(:likes_count)
    @username = current_user.username
    @trending_tags = Activity.trending_tags

    @new_posts_count = @activities.where("published_at >= ?", 24.hours.ago).count

    @pagy, @activities = pagy(@activities, limit: 10)

    respond_to do |format|
      format.html
      format.turbo_stream if params[:page].present?
    end
  end
end

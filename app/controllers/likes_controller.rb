class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity

  def toggle
    @size = params[:size] || 13
    @like = current_user.likes.find_by(activity: @activity)

    if @like
      @like.destroy
    else
      current_user.likes.create(activity: @activity)
    end

    @activity.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: feed_path }
    end
  end

  private

  def set_activity
    @activity = Activity.find_by!(slug: params[:activity_slug])
  end
end

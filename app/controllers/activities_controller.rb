class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  # GET /activities/new
  # Displays the activity type selection grid
  def new
  end

  # GET /activities/:slug
  # Catch-all route that redirects to the specific polymorphic path
  # e.g., /activities/my-concert -> /concerts/my-concert
  def show
    @activity = Activity.friendly.find(params[:slug])

    # Handle FriendlyId slug history redirects
    status = (params[:slug] != @activity.slug) ? :moved_permanently : :found
    redirect_to @activity.specific_path, status: status
  end
end

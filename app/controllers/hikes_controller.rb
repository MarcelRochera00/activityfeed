class HikesController < ApplicationController
  before_action :authenticate_user!

  include ActivityActions

  def parse_gpx
    if params[:gpx_file].present?
      result = GpxParser.parse(params[:gpx_file].path)
      render json: result
    else
      render json: { error: "No file provided" }, status: :bad_request
    end
  rescue => e
    render json: { error: "Failed to parse GPX: #{e.message}" }, status: :unprocessable_entity
  end

  private

  def hike_params
    h_params = params.require(:hike).permit(
      :distance_km, :duration, :elevation_gain, :trail_name, :route,
      activity_attributes: [ :id, :title, :body, :preview_image, tag_ids: [] ]
    )
    if h_params[:route].is_a?(String) && h_params[:route].present?
      begin
        h_params[:route] = JSON.parse(h_params[:route])
      rescue JSON::ParserError
        # Keep as is
      end
    end
    h_params
  end
end

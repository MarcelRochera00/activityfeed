class ConcertsController < ApplicationController
  before_action :authenticate_user!

  include ActivityActions
  def search_artists
    artists = SetlistFmService.search_artists(params[:q])
    render json: artists
  end

  def search_concerts
    concert_data = SetlistFmService.search_concerts(params[:artist], params[:date])
    render json: concert_data
  end

  private

  def concert_params
    params.require(:concert).permit(
      :artist, :venue, :date, :tracklist,
      activity_attributes: [ :id, :title, :body, :preview_image, tag_ids: [] ]
    )
  end
end

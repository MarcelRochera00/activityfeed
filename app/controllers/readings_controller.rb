class ReadingsController < ApplicationController
  before_action :authenticate_user!
  include ActivityActions

  def search_books
    require_relative "../services/open_library_service"
    results = ::OpenLibraryService.search(params[:q], mode: params[:mode])

    if results.is_a?(Hash) && results[:error]
      status = results[:status] || :internal_server_error
      render json: results, status: status
    else
      render json: { books: results }
    end
  end

  private

  def reading_params
    params.require(:reading).permit(
      :isbn, :title, :author, :cover_url,
      activity_attributes: [ :id, :title, :body, :preview_image, tag_ids: [] ]
    )
  end
end

# /app/controllers/search_controller.rb
class SearchController < ApplicationController
  before_action :force_json, only: :autocomplete
  def autocomplete
    @movies = Movie.ransack(title_cont: params[:title]).result(distinct: true)
    # @directors = Director.ransack(name_cont: params[:q]).result(distinct: true)

    respond_to do |format|
      format.json {
        @movies = @movies.limit(30)
        # @directors = @directors.limit(5)
      }
    end

    # @movies = Movie.order(popularity: :asc).where("title like ?", "%#{params[:title]}%").limit(100)
  end

  def search
    @pagy, @movies = pagy(Movie.ransack(title_cont: params[:title]).result(distinct: true), items: 30)
    # ahoy.track 'Searched movie', title: params[:title]
    return if @movies.exists?

    ahoy.track 'Movie not found'
    flash[:alert] = movie_title + ' not found'
    params.delete :title
    redirect_back(fallback_location: movies_path)
    # @directors = Director.ransack(name_cont: params[:q]).result(distinct: true)

    # @movies = Movie.order(popularity: :asc).where("title like ?", "%#{params[:title]}%").limit(100)
  end
end

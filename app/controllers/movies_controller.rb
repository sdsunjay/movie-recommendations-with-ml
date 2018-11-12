class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :set_user_reviews, only: [:show, :index]
  before_action :require_admin, only: [:create, :new, :edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    @per_page = params[:per_page] || 30
    if params[:title].present?
      @page_title = params[:title]
      help_index(params[:title])
    else
      @page_title = 'Movies'
      @pagy, @movies = pagy(Movie.all, items: @per_page)
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @page_title = 'Movie'
  end

  # GET /movies/new
  def new
    @movie = current_user.movies.build
    @genres = Genre.all
  end

  # GET /movies/1/edit
  def edit
    @page_title = 'Edit Movie'
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = current_user.movies.build(movie_params)

    respond_to do |format|
      if @movie.save
        @movie.genres.create(params[:genre])
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def help_index(movie_title)
    ahoy.track 'Searched movie', title: movie_title
    @pagy, @movies = pagy(Movie.search(movie_title), items: 33)
    return unless !@movies.exists?

    ahoy.track 'Movie not found'
    flash[:alert] = movie_title + ' not found'
    params.delete :title
    redirect_back(fallback_location: movies_path)
  end

  def movie_detail
    movie_service.movie_detail(params['id'])
  end

  def image_path
    @image_path ||= movie_service.configuration.base_url
  end

  def movie_service
    @movie_service ||= MovieDbService.new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie ||= Movie.find(params[:id])
    @review = Review.where(movie_id: params[:id], user_id: current_user.id)
    @genres = Genre.all
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def movie_params
    accessible = [:title, :vote_count, :vote_average, :tagline, :status, :poster_path, :original_language, :backdrop_path, :adult, :overview, :popularity, :budget, :release_date, :revenue, :runtime, :position, :genre_ids => []]
    params.require(:movie).permit(accessible)
  end

  # Utility methods
  def genres
    @genres = Genre.all
    @movie_genres = @movie.categorizations.build
  end
end

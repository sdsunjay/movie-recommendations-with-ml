class MoviesController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
    before_action :set_movie, only: [:show, :edit, :update, :destroy]
    before_action :set_movie_review, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, only: [:create, :new, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    # @facebook_movies = Facebook.get_object(current_user.token, '/me/movies?fields=name')
    # puts @facebook_movies
    #  @movies = Facebook.get_object(current_user.token, '/me/movies?fields=name')
    # @movies = movie_service.popular
    if params[:title].present?
      ahoy.track "Searched movie", title: params[:title]
      @pagy, @movies = pagy(Movie.search(params[:title]), items: 99)
      if @movies.blank?
        ahoy.track "Movie not found"
        flash[:alert] = params[:title] + ' not found'
        redirect_back(fallback_location: movies_path)
      end
    else
      @pagy, @movies = pagy(Movie.all.order(created_at: :asc), items: 99)
    end
  end

  def like
    @movie = Movie.find(params[:id])
    @review = Review.new
    if !Review.where(movie_id: @movie.id, user_id: current_user.id).exists?
      @review.user_id = current_user.id
      @review.movie_id = @movie.id
      @review.rating = 5
      if @review.save
        flash[:notice] = 'Review has been saved successfully.'
        redirect_back(fallback_location: movies_path)
      else
        flash[:alert] = 'Database Error'
        redirect_back(fallback_location: movies_path)
      end
    else
        flash[:alert] = 'You have already reviewed this movies'
        redirect_back(fallback_location: movies_path)
    end
  end
  def dislike
    @movie = Movie.find(params[:id])
    @review = Review.new
    if !Review.where(movie_id: @movie.id, user_id: current_user.id).exists?
      @review.user_id = current_user.id
      @review.movie_id = @movie.id
      @review.rating = 1
      if @review.save
        flash[:notice] = 'Review has been saved successfully.'
        redirect_back(fallback_location: movies_path)
      else
        flash[:alert] = 'Database Error'
        redirect_back(fallback_location: movies_path)
      end
    else
        flash[:alert] = 'You have already reviewed this movies'
        redirect_back(fallback_location: movies_path)
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end


  # GET /movies/new
  def new
    @movie = current_user.movies.build
    get_genres
  end

  # GET /movies/1/edit
  def edit
    get_genres
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


   private

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
    @movie = Movie.find(params[:id])
  end

  def set_movie_review
    @reviews = @user.reviews
    @movie_review = @reviews.where(movie_id: @movie.id).first
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def movie_params
    params
      .require(:movie)
      .permit(:title, :vote_count, :vote_average, :tagline, :status, :poster_path, :original_language, :backdrop_path, :adult, :overview, :popularity, :budget, :release_date, :revenue, :runtime, :genre_ids => [])
  end

  # Utility methods
  def get_genres
    @genres = Genre.all
    @movie_genres = @movie.categorizations.build
  end

end

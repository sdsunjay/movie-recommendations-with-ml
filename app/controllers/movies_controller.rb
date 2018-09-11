class MoviesController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :set_movie, only: [:show, :edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    #  @movies = Facebook.get_object(current_user.token, '/me/movies?fields=name')
    # @movies = movie_service.popular
    # @genres = Genre.all
    if params[:query].present?
      @movies = Movie.search(params[:query], page: params[:page])
    else
      @movies = Movie.all.order(created_at: :desc).paginate(per_page: 10, page: params[:page])
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
        redirect_to movies_path, :notice => "Review has been saved successfully."
      else
        redirect_to movies_path, :alert => 'Database error'
      end
    else
        redirect_to movies_path, :alert => 'You have already reviewed this movie'
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
        redirect_to movies_path, :notice => "Review has been saved successfully."
      else
        redirect_to movies_path, :alert => 'Database error'
      end
    else
        redirect_to movies_path, :alert => 'You have already reviewed this movie'
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
      @movie = Movie.find(params[:id])
  end


  # GET /movies/new
  def new
    # @movie = current_user.movies.build
    @movie = current_user.movies.build
    get_genres
    # @movie.categorizations.build
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
  # def destroy
  #  @movie.destroy
  #  respond_to do |format|
  #    format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  # end

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

    # Never trust parameters from the scary internet, only allow the white list through.

    def movie_params
      params
        .require(:movie)
        .permit(:title, :vote_count, :vote_average, :tagline, :status, :poster_path, :original_language, :backdrop_path, :adult, :overview, :popularity, :budget, :release_date, :revenue, :runtime, :genre_ids => [])
        .merge(user_id: current_user.id)
    end
    # Utility methods
    def get_genres
      @genres = Genre.all
      @movie_genres = @movie.categorizations.build
      # @movie_genre = @movie.genres.build
    end

end

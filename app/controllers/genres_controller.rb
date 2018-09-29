class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :require_admin, only: [:edit, :new, :update, :destroy]
  # GET /genres
  # GET /genres.json
  def index
      @genres = Genre.all.order(created_at: :desc).paginate(per_page: 99, page: params[:page])
      @reviews =  @user.reviews.order(created_at: :desc)
  end

  # GET /genres/1
  # GET /genres/1.json
  def show
      # @genres = Genre.all
      @movies = @genre.movies.all.order(created_at: :asc).paginate(per_page: 99, page: params[:page])
      @reviews =  @user.reviews.order(created_at: :desc)
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
     @genre = Genre.find_by(id: params[:id])
     @movies = Movie.all
     @moviesTheGenreIncludes = @genre.movies.pluck(:id)
  end

  # POST /genres
  # POST /genres.json
  def create
    @genre = Genre.new(genre_params)

    respond_to do |format|
      if @genre.save
        format.html { redirect_to @genre, notice: 'Genre was successfully created.' }
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /genres/1
  # PATCH/PUT /genres/1.json
  def update
    respond_to do |format|
      if @genre.update(genre_params)
        format.html { redirect_to @genre, notice: 'Genre was successfully updated.' }
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :edit }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /genres/1
  # DELETE /genres/1.json
  def destroy
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_url, notice: 'Genre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def genre_params
      params.require(:genre).permit(:name)
    end
end

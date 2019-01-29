class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_user_reviews, only: [:show]
  before_action :require_admin, only: [:index, :new, :create, :edit, :destroy, :update]
  before_action :set_per_page, only: %i[show]
  caches_action :index

  # GET /genres
  # GET /genres.json
  def index
    @page_title = 'Genres'
    @genres = Genre.all
  end

  # GET /genres/1
  # GET /genres/1.json
  def show
    @page_title = @genre.name
    @pagy, @movies = pagy(@genre.movies.all, items: @per_page)
  end

  # GET /genres/new
  def new
    @genre = Genre.new
    @page_title = 'New Genre'
  end

  # GET /genres/1/edit
  def edit
    @page_title = 'Edit Genre'
    @movies_the_genre_includes = @genre.movies.pluck(:id)
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
    @genre ||= Genre.find(params[:id])
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def genre_params
    params.require(:genre).permit(:name)
  end
end

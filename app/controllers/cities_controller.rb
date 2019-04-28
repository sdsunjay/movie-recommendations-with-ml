class CitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_lists
  before_action :require_admin, except: [:show, :search, :autocomplete]
  before_action :force_json, only: :autocomplete
  before_action :set_per_page, only: %i[index]
  caches_action :index, :show

  # GET /cities
  # GET /cities.json
  def index
    @page_title = 'Cities'
    @pagy, @cities = pagy(City.includes(:state).all, items: @per_page)
    @number_of_cities = City.all.count
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
   @educations = @city.educations
   @number_of_educations = @city.educations.count
   @pagy, @educations = pagy(@city.educations, items: 30)
   @page_title = @city.name
  end

  # GET /cities/new
  def new
    @city = City.new
    @states = State.all
    @page_title = 'New City'
  end

  # GET /cities/1/edit
  def edit
    @states = State.all
    @page_title = 'Edit City'
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        @page_title = 'New City'
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        @states = State.all
        @page_title = 'Edit City'
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @cities = City.ransack(name_cont: params[:name]).result(distinct: true)

    respond_to do |format|
      format.json {
        @cities = @cities.limit(10)
      }
    end
  end

  def search
    @pagy, @cities = pagy(City.ransack(name_cont: params[:name]).result(distinct: true), items: 30)

    ahoy.track 'Searched city', city: params[:name]
    @city = params[:name]
    @page_title = @city
    # redirect_to search_cities_path if @cities.exists?
    return if @cities.exists?

    ahoy.track 'City not found'
    flash[:alert] = @city + ' not found'
    params.delete :name
    redirect_back(fallback_location: cities_path)
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city ||= City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :state_id)
    end
end

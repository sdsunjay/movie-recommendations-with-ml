class CountriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_country, only: %i[show edit update destroy]
  before_action :set_user, only: %i[index show edit update destroy]
  before_action :set_lists
  before_action :require_admin, except: %i[show]
  caches_action :index

  # GET /countries
  # GET /countries.json
  def index
    @page_title = 'Countries'
    @countries = Country.all
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
    @page_title = @country.name
  end

  # GET /countries/new
  def new
    @page_title = 'New Country'
    @country = Country.new
  end

  # GET /countries/1/edit
  def edit
    @page_title = 'Edit Country'
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(country_params)

    respond_to do |format|
      if @country.save
        format.html { redirect_to @country, notice: 'Country was successfully created.' }
        format.json { render :show, status: :created, location: @country }
      else
        @page_title = 'New Country'
        format.html { render :new }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to @country, notice: 'Country was successfully updated.' }
        format.json { render :show, status: :ok, location: @country }
      else
        @page_title = 'Edit Country'
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Country was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:iso, :name, :printable_name, :iso3, :numcode)
    end
end

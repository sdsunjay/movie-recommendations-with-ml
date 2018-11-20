class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_user_reviews, only: [:show]
  before_action :require_admin, only: [:index, :new, :create, :edit, :destroy, :update]
  caches_action :index

  # GET /companies
  # GET /companies.json
  def index
    @page_title = 'Companies'
    @companies = Company.all.order(created_at: :desc)
  end

  # GET /companiess/1
  # GET /companies/1.json
  def show
    @per_page = params[:per_page] || 30
    @page_title = @company.name
    @movies = Movie.first(30)
    @pagy, @movies = pagy(@company.movies, items: @per_page)
  end

  # GET /companies/new
  def new
    @page_title = 'New Company'
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    @page_title = 'Edit Company'
    @movies = Movie.all
    @movies_the_company_includes = @company.movies.pluck(:id)
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company ||= Company.find(params[:id])
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def company_params
    # extend with your own params
    accessible = %i[name description homepage logo_path origin_country parent_company_id]
    params.require(:company).permit(accessible)
  end
end

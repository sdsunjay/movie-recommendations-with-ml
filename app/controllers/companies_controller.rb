class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_user_reviews, only: [:show]
  before_action :require_admin, except: [:show]
  before_action :set_per_page, only: %i[show index]
  caches_action :index

  # GET /companies
  # GET /companies.json
  def index
    @page_title = 'Companies'
    @pagy, @companies = pagy(Company.all.order(created_at: :desc), items: @per_page)
    @number_of_companies = Company.all.count
  end

  # GET /companiess/1
  # GET /companies/1.json
  def show
    @page_title = @company.name
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

  def search
    @pagy, @companies = pagy(Company.ransack(name_cont: params[:company_name]).result(distinct: true), items: 30)

    ahoy.track 'Searched Company', education: params[:company_name]
    @page_title = params[:company_name]
    return if @educations.exists?

    flash[:alert] = 'Not found'
    params.delete :company_name
    redirect_back(fallback_location: companies_path)
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

class StatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_state, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :require_admin, except: [:show]
  caches_action :index, :show

  # GET /states
  # GET /states.json
  def index
    @page_title = 'States'
    @states = State.all
  end

  # GET /states/1
  # GET /states/1.json
  def show
   @cities = @state.cities
   @number_of_cities = @state.cities.count
   @pagy, @cities = pagy(@state.cities, items: 30)
   @page_title = @state.name
  end

  # GET /states/new
  def new
    @state = State.new
    @page_title = 'New State'
  end

  # GET /states/1/edit
  def edit
    @page_title = 'Edit State'
  end

  # POST /states
  # POST /states.json
  def create
    @state = State.new(state_params)

    respond_to do |format|
      if @state.save
        format.html { redirect_to @state, notice: 'State was successfully created.' }
        format.json { render :show, status: :created, location: @state }
      else
        format.html { render :new }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: 'State was successfully updated.' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @state.destroy
    respond_to do |format|
      format.html { redirect_to states_url, notice: 'State was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      # extend with your own params
      accessible = %i[iso name country_id]
      params.require(:state).permit(accessible)
    end
end

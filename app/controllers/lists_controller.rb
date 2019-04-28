class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_list, only: %i[show edit update destroy]
  before_action :set_lists, only: %i[show edit update destroy]
  before_action :set_user_reviews, only: %i[show]
  before_action :require_admin, only: %i[index]
  before_action :set_per_page, only: %i[show]

  # GET /lists
  # GET /lists.json
  def index
    @page_title = 'Lists'
    @pagy, @lists = pagy(List.all, items: @per_page)
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @page_title = @list.name
    @pagy, @movies = pagy(@list.movies, items: @per_page)
  end

  # GET /lists/new
  def new
    if !@user.list_limit_exceeded?
      @list = List.new
      @page_title = 'New List'
    else
      respond_to do |format|
        format.html { redirect_to @user, alert: 'You already have 5 lists' }
        format.json { render :show, status: :error, location: @user }
      end
    end

  end

  # GET /lists/1/edit
  def edit
    @page_title = 'Edit ' + @list.name
  end

  # POST /lists
  # POST /lists.json
  def create
    if !@user.list_limit_exceeded?
      @list = List.new(list_params.merge(user_id: @user.id))

      respond_to do |format|
        if @list.save
          format.html { redirect_to @list, notice: 'List was successfully created.' }
          format.json { render :show, status: :created, location: @list }
        else
          format.html { render :new }
          format.json { render json: @list.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params.merge(user_id: @user.id))
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list ||= @user.lists.where(id: params[:id]).first
    unless @list.present?
      flash[:alert] = 'List does not belong to you'
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
        format.js {}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def list_params
    params.require(:list).permit(:name, :description, :user_id)
  end
end

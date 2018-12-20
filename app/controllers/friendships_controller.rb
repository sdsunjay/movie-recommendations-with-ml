class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :require_admin, except: [:show]

  # GET /friendships
  # GET /friendships.json
  def index
    @page_title = 'Friendships'
    @pagy, @friends = pagy(Friendship.includes(:user).all.order(created_at: :desc), items: 30)
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
    @page_title = 'Friends'
    @friends = @user.friendships
  end

  # GET /friendships/new
  def new
    @page_title = 'New Friendship'
    @friendship = Friendship.new
    @users = User.all
  end

  # GET /friendships/1/edit
  def edit
    @page_title = 'Edit Friendship'
    @users = User.all
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(friendship_params)
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to @friendship, notice: 'Friendship was successfully created.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { render :new }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    respond_to do |format|
      if @friendship.update(friendship_params)
        format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { render :show, status: :ok, location: @friendship }
      else
        format.html { render :edit }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def friendship_params
    params
      .require(:friendship)
      .permit(:friend_id, :user_id)
  end

end

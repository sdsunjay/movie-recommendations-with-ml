class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[index show edit update destroy]
  before_action :set_friendship, only: %i[show edit update destroy]
  before_action :set_lists, only: %i[show edit update destroy]
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
    @page_title = @friendship.friend.name
    @pagy_reviews, @reviews = pagy(@friendship.friend.reviews.includes(:movie).order(created_at: :desc), page_param: :page_reviews, params: { active_tab: 'reviews-tab' })
    if @reviews.blank?
      @avg_review = 0
      @number_of_reviews = 0
      @number_of_liked_movies = 0
      @number_of_disliked_movies = 0
    else
      @number_of_reviews = @friendship.friend.reviews.count
      @avg_review = @friendship.friend.reviews.average(:rating).round(2)
      @number_of_liked_movies = Review.where(user_id: @friendship.friend_id, rating: 5).count
      @number_of_disliked_movies = Review.where(user_id: @friendship.friend_id, rating: 1).count
    end
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
    @friendship = current_user.friendships.build(friendship_params)
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to @friendship, notice: 'Added friend.' }
        format.json { render current_user, status: :created, location: @friendship }
      else
        format.html { redirect_to user_path(current_user), alert: 'Unable to add friend' }
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
      format.html { redirect_to current_user, notice: 'Removed friendship' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = current_user.friendships.find(params[:id])
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def friendship_params
    params
      .require(:friendship)
      .permit(:friend_id, :user_id)
  end
end

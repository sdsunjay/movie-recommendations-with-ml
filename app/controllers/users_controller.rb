class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[destroy index]
  caches_action :index

  # GET /users
  # GET /users.json
  def index
    @page_title = 'Accounts'
    @pagy, @users = pagy(User.all.order(created_at: :desc), items: 99)
  end

  # GET /users/:id.:format
  def show
    @page_title = 'Account'
    @friends = Friendship.where(user_id: @user).order(created_at: :desc)

    @pagy_reviews, @reviews = pagy(@user.reviews.includes(:movie).order(created_at: :desc), items: 33)
    @pagy_recommendations, @recommendations = pagy(@user.movie_user_recommendations.includes(:movie).order(created_at: :desc), items: 33)
    @friends_count = if @friends.blank?
                       0
                     else
                       @friends.count
                     end
    if @reviews.blank?
      @avg_review = 0
      @number_of_reviews = 0
      @number_of_liked_movies = 0
      @number_of_disliked_movies = 0

    else
      @number_of_reviews = @user.reviews.count
      @avg_review = @user.reviews.average(:rating).round(2)
      @number_of_liked_movies = Review.where(user_id: @user, rating: 5).count
      @number_of_disliked_movies = Review.where(user_id: @user, rating: 1).count

    end
    if @recommendations.blank?
      @number_of_recommendations = 0
    else
      @number_of_recommendations = @recommendations.count
    end
  end


  # GET /users/:id/edit
  def edit
    @page_title = 'Edit Account'
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        # Sign in the user bypassing validation
        bypass_sign_in(@user)
        format.html { redirect_to user_path, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user

    @user.reviews.each(&:destroy)
    @user.friendships.each(&:destroy)
    @user.movie_user_recommendtions.each(&:destroy)
    @user.movies.each(&:destroy)

    if @user.destroy
      flash[:notice] = 'User Removed'
      redirect_to users_path
    else
      render 'destroy'
    end
  end

  private

  def user_params
    # extend with your own params
    accessible = %i[name email gender hometown location education birthday link]
    params.require(:user).permit(accessible)
  end
end

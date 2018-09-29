class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update]
    before_action :require_admin, only: [:destroy, :index]

    def index
        @users = User.all.order(created_at: :desc).paginate(per_page: 99, page: params[:page])
    end

    # GET /users/:id.:format
    def show
      @friends = Friendship.where(user_id: @user).order(created_at: :desc).paginate(per_page: 99, page: params[:friends_page])

      @reviews = Review.includes(:movie).where(user_id: @user).order(created_at: :desc).paginate(per_page: 99, page: params[:reviews_given_page])
      if @reviews.blank?
        @avg_review = 0
        @number_of_reviews = 0
        @number_of_liked_movies = 0
        @number_of_disliked_movies = 0
      else
        @number_of_reviews = @user.reviews.count()
        @avg_review = @user.reviews.average(:rating).round(2)
        @number_of_liked_movies = Review.where(user_id: @user, rating: 5).count()
        @number_of_disliked_movies = Review.where(user_id: @user, rating: 1).count()
      end
    end

    # GET /users/:id/edit
    def edit
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
    #     #authorize! :delete, @user

        @user = User.destroy(params[:id])
        @user.reviews.each{|review| review.destroy}
        @user.friendships.each{|friendship| friendship.destroy}

        if @user.destroy
          flash[:notice] = "User Removed"
          redirect_to users_path
        else
          render 'destroy'
        end
    end

    private

    def user_params
       accessible = [ :name, :email, :gender, :hometown, :location, :education] # extend with your own params
       params.require(:user).permit(accessible)
    end
end

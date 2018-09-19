class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update]
    before_action :require_admin, only: [:destroy]

    def index
        #authorize!
        @users = User.all.order(created_at: :desc).paginate(per_page: 10, page: params[:page])
        unless current_user.admin? || current_user.super_admin?
            unless @user == current_user
                redirect_to root_path, alert: 'Access denied.'
            end
        end
    end

    # GET /users/:id.:format
    def show
      @reviews = Review.includes(:movie).where(user_id: @user).order(created_at: :desc).paginate(per_page: 15, page: params[:page])
      if @reviews.blank?
        @avg_review = 0
      else
        @number_of_reviews = @user.reviews.count()
        @avg_review = @reviews.average(:rating).round(2)
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
                # Sign in the user by passing validation in case his password changed
                sign_in @user, :bypass => true
                # sign_in(@user == current_user ? @user : current_user, bypass: true)
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
        if @user.destroy
          flash[:notice] = "User Removed"
          redirect_to root_path
        else
          render 'destroy'
        end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
       accessible = [ :name, :email, :gender, :hometown, :location, :education] # extend with your own params
       params.require(:user).permit(accessible)
    end
end

class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update]

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
        # @posts = Post.where(user_id: @user.id).order(created_at: :desc).paginate(per_page: 5, page: params[:page])
      @reviews = Review.includes(:movie).where(user_id: @user).order(created_at: :desc).paginate(per_page: 15, page: params[:page])
      if @reviews.blank?
        @avg_review = 0
      else
        @avg_review = @reviews.average(:rating).round(2)
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
                sign_in(@user == current_user ? @user : current_user, bypass: true)
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

        #@user = User.destroy(params[:id])
        #@user.posts.each{|post| post.destroy}
        # @user.reviews.each{|post| post.destroy}
        # if @user.destroy
        #  flash[:notice] = "User Removed"
        #  redirect_to root_path
        #else
        #  render 'destroy'
        #end
    end

    private

    def set_user
      @user = User.find(params[:id])
      @user.friends
    end

    def user_params
       accessible = [ :name, :email] # extend with your own params
       accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
       params.require(:user).permit(accessible)
    end
end

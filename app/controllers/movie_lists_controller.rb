class MovieListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]
  before_action :set_movie, only: %i[create destroy]
  before_action :set_list, only: %i[create destroy]
  before_action :set_lists, only: %i[create destroy]
  before_action :set_movie_list, only: %i[destroy]

  # POST /reviews
  # POST /reviews.json
  def create
    return unless params[:id].present?
    return unless params[:list_id].present?

    MovieList.where(movie_id: @movie.id, list_id: @list.id ).first_or_create
    @list = List.find(@list.id)
      respond_to do |format|
        format.html { redirect_to @movie }
        format.js { flash[:notice] = 'Movie added' }
        format.json { render :show, status: :created, location: @movie }
      end
  end

  # DELETE /movie_lists/1
  # DELETE /movie_lists/1.json
  def destroy
    #puts @movie_list.id
    if @movie_list.destroy
      @list = List.find(@list.id)
      respond_to do |format|
        format.js {  flash[:notice] = 'Movie was successfully removed from list' }
        format.html { redirect_to @movie, notice: 'Movie was successfully removed from list' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.js {  flash[:alert] = 'Movie was not removed from list' }
        format.html { redirect_to @movie, alert: 'Movie was not removed from list' }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_movie_list
    @movie_list = MovieList.find_by(list_id: @list.id, movie_id: @movie.id)
  end

  def set_movie
    unless (@movie ||= Movie.find(params[:id]))
      flash[:alert] = 'Must specify movie.'
      redirect_to root_path
    end
  end

  def set_list
    unless params[:list_id].present?
      flash[:alert] = 'Must specify list.'
      redirect_to root_path
    end
    @list ||= @user.lists.where(id: params[:list_id]).first if params[:list_id].present?
    unless @list.present?
      flash[:alert] = 'List does not belong to you'
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
        format.js {}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def movie_list_params
    # extend with your own params
    accessible = %i[list_id movie_id]
    params.require(:movielist).permit(accessible)
  end

end

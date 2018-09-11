# /app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    if params.keys.all? { |key, value| ['title'].include? key }
      return @movies = Movie.search(params[:title]).order(created_at: :desc).paginate(per_page: 10, page: params[:page])
    end
  end
end

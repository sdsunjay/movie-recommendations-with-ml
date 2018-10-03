# /app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    if params.keys.all? { |key, _value| ['title'].include? key }
      @movies = Movie.search(params[:title]).order(created_at: :desc)
    end
  end
end

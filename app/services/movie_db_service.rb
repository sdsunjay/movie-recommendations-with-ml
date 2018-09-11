class MovieDbService
  attr_reader :configuration

  def initialize
    @configuration = Tmdb::Configuration.new
    @tmdb = Tmdb::Movie
  end

  def popular
    @tmdb.popular
  end

  def movie_detail(id)
    return unless id
    casts_for(@tmdb.detail(id))
  end

  def find(keyword)
    @tmdb.find(keyword) if keyword
  end

  def genres
    Tmdb::Genre.movie_list
  end

  private

  def casts_for(movie)
    movie.merge('casts' => @tmdb.casts(movie['id']).map { |cast| cast['name'] })
  end
end

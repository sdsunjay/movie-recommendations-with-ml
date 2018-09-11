class MoviePresenter
  def initialize(movie)
    @movie = movie
  end

  def data
    OpenStruct.new(
      title: @movie['title'],
      poster_path: @movie['poster_path'],
      # TODO fix this so that it maps the genre to the genre table
      # genres: @movie['genres'].map { |genre| genre['name'] }.join(' / '),
      overview: @movie['overview'],
      # rating: @movie['rating'],
      # casts: @movie['casts'],
      tagline: @movie['tagline'],
      runtime: @movie['runtime'],
      release_date: @movie['release_date'],
      revenue: @movie['revenue']
    )
  end
end

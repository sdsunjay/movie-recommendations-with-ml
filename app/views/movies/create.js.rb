$("#rating_<%= @movie.id %>_review").html("<%=j render partial: "movies/index", locals: {movie: movie} %>");

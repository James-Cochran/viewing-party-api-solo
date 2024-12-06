class MovieSerializer
  def self.format_movies(movies)
    movies.first(20).map do |movie|
      {
        id: movie.id,
        type: "movie",
        attributes: {
          title: movie.title,
          vote_average: movie.vote_average
        }
      }
    end
  end
end
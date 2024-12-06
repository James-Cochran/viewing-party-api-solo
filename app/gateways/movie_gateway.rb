class MovieGateway
  def self.top_rated_movies(api_key)
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated", { api_key: api_key })
    movies = JSON.parse(response.body, symbolize_names: true)[:results]
    movies.map { |movie| Movie.new(movie) }
  end

  def self.search_movies(query, api_key)
    response = Faraday.get("https://api.themoviedb.org/3/search/movie", { api_key: api_key, query: query })
    movies = JSON.parse(response.body, symbolize_names: true)[:results]
    movies.map { |movie| Movie.new(movie) }
  end
end

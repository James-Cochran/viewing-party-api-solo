class Api::V1::MoviesController < ApplicationController
  def index
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated?api_key=dc229d04fae6c82dd1fb9af1103f94fe")
    movies = JSON.parse(response.body, symbolize_names: true)[:results]

    formatted_movies = movies.first(20).map do |movie|
      {
        id: movie[:id].to_s,
        type: "movie",
        attributes: {
          title: movie[:title],
          vote_average: movie[:vote_average]
        }
      }
    end

    render json: { data: formatted_movies }, status: :ok
  end

end
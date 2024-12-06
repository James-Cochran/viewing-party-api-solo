class Api::V1::MoviesController < ApplicationController
  def index
    api_key = ENV['THEMOVIEDB_KEY'] || Rails.application.credentials.themoviedb[:key]

    movies = if params[:query]
                MovieGateway.search_movies(params[:query], api_key)
              else
                MovieGateway.top_rated_movies(api_key)
              end

    render json: { data: MovieSerializer.format_movies(movies) }, status: :ok
  end
end
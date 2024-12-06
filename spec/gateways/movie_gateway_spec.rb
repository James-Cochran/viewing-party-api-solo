require "rails_helper"

RSpec.describe MovieGateway do
  describe ".top_rated_movies" do
    it "can retrieve a list of 20 top rated movies" do
      api_key = Rails.application.credentials.themoviedb[:key] || ENV['THEMOVIEDB_KEY']
      json_response = File.read('spec/fixtures/top_rated_movies.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{Rails.application.credentials.themoviedb[:key]}")
        .to_return(status: 200, body: json_response)
    
      top_rated_movies = MovieGateway.top_rated_movies(api_key)

      expect(top_rated_movies).to be_an(Array)
      expect(top_rated_movies.first).to be_a(Movie)

      first_movie = top_rated_movies.first
      expect(first_movie.id).to eq(278)
      expect(first_movie.title).to eq("The Shawshank Redemption")
      expect(first_movie.vote_average).to eq(8.707)
    end
  end

  describe ".search_movies" do
    it "can retrieve a list of movies based on a search query" do
      api_key = Rails.application.credentials.themoviedb[:key] || ENV['THEMOVIEDB_KEY']
      json_response = File.read('spec/fixtures/lord_of_the_rings.json')
      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { api_key: Rails.application.credentials.themoviedb[:key], query: "Lord of the Rings" })
        .to_return(status: 200, body: json_response)

      search_results = MovieGateway.search_movies("Lord of the Rings", api_key)

      expect(search_results).to be_an(Array)
      expect(search_results.first).to be_a(Movie)

      first_movie = search_results.first
      expect(first_movie.id).to eq(120)
      expect(first_movie.title).to include("The Lord of the Rings")
      expect(first_movie.vote_average).to eq(8.416)
    end
  end
end
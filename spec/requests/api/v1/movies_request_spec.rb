require 'rails_helper'

RSpec.describe 'Movies Endpoints', type: :request do
  describe "happy path" do
    it "can retrieve a list of 20 top rated movies" do
      json_response = File.read('spec/fixtures/top_rated_movies.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{Rails.application.credentials.themoviedb[:key]}")
        .to_return(status: 200, body: json_response)

      get "/api/v1/movies"  

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json.count).to eq(20) 

      movie = json.first
      expect(movie[:type]).to eq("movie")
      expect(movie[:id]).to be_a(Integer)
      expect(movie[:attributes]).to have_key(:title)
      expect(movie[:attributes]).to have_key(:vote_average)
    end

    describe "Movie Search" do
      it "can retrieve a list of movies based on a search query" do
        json_response = File.read('spec/fixtures/lord_of_the_rings.json')
        stub_request(:get, "https://api.themoviedb.org/3/search/movie")
          .with(query: { api_key: Rails.application.credentials.themoviedb[:key], query: "Lord of the Rings" })
          .to_return(status: 200, body: json_response)
  
        get "/api/v1/movies?query=Lord+of+the+Rings"
  
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]
  
        expect(json.count).to be <= 20 
        
        first_movie = json.first
        expect(first_movie[:attributes][:title]).to eq("The Lord of the Rings: The Fellowship of the Ring")
        expect(first_movie[:type]).to eq("movie")
        expect(first_movie[:id]).to be_a(Integer)
        expect(first_movie[:attributes]).to have_key(:title)
        expect(first_movie[:attributes]).to have_key(:vote_average)
      end
    end
  end
end
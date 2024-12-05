require 'rails_helper'

RSpec.describe 'Top Rated Movies', type: :request do
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
      expect(movie[:id]).to be_a(String)
      expect(movie[:attributes]).to have_key(:title)
      expect(movie[:attributes]).to have_key(:vote_average)
    end
  end
end
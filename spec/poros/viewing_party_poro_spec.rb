require "rails_helper"

RSpec.describe ViewingParty do
  describe "initialize" do
    it "populates attributes from a JSON hash" do
      fixture_data = File.read("spec/fixtures/christmas_vacation.json")
      movie_data = JSON.parse(fixture_data, symbolize_names: true)[:results].first
      
      movie = Movie.new(movie_data)
      
      expect(movie.id).to eq(5825)
      expect(movie.title).to eq("National Lampoon's Christmas Vacation")
    end
  end
end

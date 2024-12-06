require "rails_helper"

RSpec.describe Movie do
  describe "initialize" do
    it "populates attributes from a JSON hash" do
      sample_input_raw = File.read("spec/fixtures/lord_of_the_rings.json")
      sample_input = JSON.parse(sample_input_raw, symbolize_names: true)[:results].first

      result_movie = Movie.new(sample_input)

      expect(result_movie.id).to eq(120)
      expect(result_movie.title).to eq("The Lord of the Rings: The Fellowship of the Ring")
      expect(result_movie.vote_average).to eq(8.416)
    end
  end
end
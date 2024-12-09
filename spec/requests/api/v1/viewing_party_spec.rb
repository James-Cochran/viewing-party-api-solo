require 'rails_helper'

RSpec.describe "Viewing Party Endpoints", type: :request do
  before(:each) do
    Rails.application.load_seed

    json_response = File.read('spec/fixtures/christmas_vacation.json')
    stub_request(:get, "https://api.themoviedb.org/3/search/movie")
      .with(query: hash_including({ api_key: Rails.application.credentials.themoviedb[:key], query: "National Lampoon's Christmas Vacation" }))
      .to_return(status: 200, body: json_response)
  end

  describe "Happy Path" do
    it "creates a viewing party and connects users" do
      host = User.find_by(username: "danny_de_v")
      invitees = [ User.find_by(username: "dollyP"), User.find_by(username: "futbol_geek") ]

      movie_id = 5825
      movie_title = "National Lampoon's Christmas Vacation"

      party_params = {
        host_username: host.username,
        name: "Holiday Movie Night",
        start_time: "2025-12-24 19:00:00",
        end_time: "2025-12-24 21:30:00",
        movie_id: movie_id,
        movie_title: movie_title,
        invitees: invitees.map { |invitee| invitee.id } 
      }

      post "/api/v1/viewing_parties", 
            params: JSON.generate(party_params),
            headers: { "CONTENT_TYPE" => "application/json" }

      expect(response).to be_successful
      expect(response.status).to eq(201)
      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json[:attributes][:name]).to eq("Holiday Movie Night")
      expect(json[:attributes][:movie_title]).to eq("National Lampoon's Christmas Vacation")
      expect(json[:attributes][:invitees].count).to eq(2)

      expected_invitees = ["Dolly Parton", "Lionel Messi"]
      actual_invitees = json[:attributes][:invitees].map { |invitee| invitee[:name] }
      expect(actual_invitees).to match_array(expected_invitees)
    end
  end

  describe "sad path" do
    it "returns an error when required attributes are missing" do
      host = User.find_by(username: "danny_de_v")
      party_params = {
        host_username: host.username,
        name: "",
        start_time: "",
        end_time: "",
        movie_id: nil,
        movie_title: nil,
        invitees: []
      }
  
      post "/api/v1/viewing_parties",
            params: JSON.generate(party_params),
            headers: { "CONTENT_TYPE" => "application/json" }
  
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Something's missing: movie title, movie ID, or invitees")
    end

    it "returns an error when party duration is less than movie runtime" do
      host = User.find_by(username: "danny_de_v")
      party_params = {
        host_username: host.username,
        name: "Too Short Party",
        start_time: "2025-12-24 19:00:00",
        end_time: "2025-12-24 19:30:00", 
        movie_id: 5825,
        movie_title: "National Lampoon's Christmas Vacation",
        invitees: [host.id]
      }
  
      post "/api/v1/viewing_parties",
            params: JSON.generate(party_params),
            headers: { "CONTENT_TYPE" => "application/json" }
  
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Party duration cannot be less than movie runtime")
    end
  
    it "returns an error when end time is before start time" do
      host = User.find_by(username: "danny_de_v")
      party_params = {
        host_username: host.username,
        name: "Backwards Time Party",
        start_time: "2025-12-24 21:30:00",
        end_time: "2025-12-24 19:00:00", 
        movie_id: 5825,
        movie_title: "National Lampoon's Christmas Vacation",
        invitees: [host.id]
      }
  
      post "/api/v1/viewing_parties",
            params: JSON.generate(party_params),
            headers: { "CONTENT_TYPE" => "application/json" }
  
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("End time cannot be before start time")
    end
  end
end
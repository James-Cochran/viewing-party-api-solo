require 'rails_helper'

RSpec.describe "Viewing Party Endpoints", type: :request do
  describe "Happy Path" do
    it "creates a viewing party and connects users" do
      host = User.find_by(username: "danny_de_v")
      invitees = [ User.find_by(username: "dollyP"), User.find_by(username: "futbol_geek") ]

      movie_id = 5825
      movie_title = "National Lampoon's Christmas Vacation"

      party_params = {
        name: "Holiday Movie Night",
        start_time: "2025-12-24 19:00:00",
        end_time: "2025-12-24 21:30:00",
        movie_id: movie_id,
        movie_title: movie_title,
        invitees: invitees.map(&:id) 
      }

      post "/api/v1/viewing_parties", params: JSON.generate(party_params)

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
end
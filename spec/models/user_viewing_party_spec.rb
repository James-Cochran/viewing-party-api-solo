require "rails_helper"

RSpec.describe UserViewingParty, type: :model do
  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:viewing_party_id) }
    it { should validate_inclusion_of(:is_host).in_array([true, false]) }
  end

  describe "relationships" do
    it { should belong_to(:user) }
    it { should belong_to(:viewing_party) }
  end
end
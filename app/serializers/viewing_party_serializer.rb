class ViewingPartySerializer
  def self.format_viewing_party(viewing_party, invitees)
    {
      data: {
        id: viewing_party.id,
        type: "viewing_party",
        attributes: {
          name: viewing_party.name,
          movie_title: viewing_party.movie_title,
          invitees: invitees.map { |invitee| { name: invitee.name } }
        }
      }
    }
  end
end
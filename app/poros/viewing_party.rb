class ViewingParty
  attr_reader :name, :start_time, :end_time, :movie_id, :movie_title, :host, :invitees

  def initialize(params, movie, host)
    @name = params[:name]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
    @movie_id = movie.id
    @movie_title = movie.title
    @host = host
    @invitees = params[:invitees]
  end

  def save_with_invitees
    viewing_party = ::ViewingParty.create!(
      name: @name,
      start_time: @start_time,
      end_time: @end_time,
      movie_id: @movie_id,
      movie_title: @movie_title
    )

    UserViewingParty.create!(user: @host, viewing_party: viewing_party, is_host: true)

    valid_invitees.each do |invitee|
      UserViewingParty.create!(user: invitee, viewing_party: viewing_party, is_host: false)
    end

    viewing_party
  end

  def valid_invitees
    User.where(id: @invitees)
  end

  def duration
    (Time.parse(@end_time) - Time.parse(@start_time)) / 60
  end
end

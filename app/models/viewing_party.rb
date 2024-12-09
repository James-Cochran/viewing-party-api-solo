class ViewingParty < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true

  has_many :user_viewing_parties
  has_many :users, through: :user_viewing_parties

  def self.new_with_validations(host, params, movie)
    viewing_party = new(
      name: params[:name],
      start_time: params[:start_time],
      end_time: params[:end_time],
      movie_id: movie.id,
      movie_title: movie.title
    )

    viewing_party.validate_party_duration(movie.runtime)
    viewing_party.validate_time_sequence
    viewing_party.validate_invitees(params[:invitees])

    viewing_party
  end

  def self.create_with_invitees(host, params)
    movie = MovieGateway.search_movies(params[:movie_title], Rails.application.credentials.themoviedb[:key])
                        .find { |movie| movie.id == params[:movie_id].to_i }

    if movie.nil?
      return { error: "Movie not found", status: 404 }
    end

    viewing_party = new_with_validations(host, params, movie)

    if !viewing_party.valid?
      return { error: viewing_party.errors.full_messages.to_sentence, status: 400 }
    end

    viewing_party.save!
    UserViewingParty.create!(user: host, viewing_party: viewing_party, is_host: true)

    invitees = User.where(id: params[:invitees])
    invitees.each do |invitee|
      UserViewingParty.create!(user: invitee, viewing_party: viewing_party, is_host: false)
    end

    { viewing_party: viewing_party, status: 201 }
  end

  def validate_party_duration(runtime)
    duration = (Time.parse(end_time.to_s) - Time.parse(start_time.to_s)) / 60
    errors.add(:base, "Party duration cannot be less than movie runtime") if duration < runtime
  end

  def validate_time_sequence
    if Time.parse(end_time.to_s) < Time.parse(start_time.to_s)
      errors.add(:base, "End time cannot be before start time")
    end
  end

  def validate_invitees(invitees)
    if invitees.blank? || User.where(id: invitees).empty?
      errors.add(:base, "No invitees found")
    end
  end
end

class Api::V1::ViewingPartiesController < ApplicationController
  def create
    api_key = ENV['THEMOVIEDB_KEY'] || Rails.application.credentials.themoviedb[:key]
    host = User.find_by(username: params[:host_username])

    if host.nil?
      render json: ErrorSerializer.format_error(ErrorMessage.new("Host not found", 400)), status: :bad_request
      return
    end

    if params_missing?
      render json: ErrorSerializer.format_error(ErrorMessage.new("Something's missing: movie title, movie ID, or invitees", 400)), status: :bad_request
      return
    end

    result = ViewingParty.create_with_invitees(host, params)

    if result[:error]
      render json: ErrorSerializer.format_error(ErrorMessage.new(result[:error], result[:status])), status: result[:status]
    else
      invitees = User.where(id: params[:invitees])
      render json: ViewingPartySerializer.format_viewing_party(result[:viewing_party], invitees), status: :created
    end
  end

  private

  def params_missing?
    params[:movie_id].nil? || params[:movie_title].nil? || params[:invitees].blank?
  end

  def find_movie(api_key)
    MovieGateway.search_movies(params[:movie_title], api_key).find do |movie|
      movie.id == params[:movie_id].to_i
    end
  end
end

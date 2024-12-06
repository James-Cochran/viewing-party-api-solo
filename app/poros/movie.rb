class Movie
  attr_reader :id, :title, :vote_average

  def initialize(data)
    @id = data[:id].to_s
    @title = data[:title]
    @vote_average = data[:vote_average]
  end
end
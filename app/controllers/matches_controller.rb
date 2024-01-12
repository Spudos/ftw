class MatchesController < ApplicationController
  def index; end

  def show
    @player_match_data = PlayerMatchData.all
  end

  def match_multiple
    match = Matches.new
    match.match_engine(params)

    redirect_to fixtures_path
  end
end

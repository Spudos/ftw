class MatchesController < ApplicationController
  def index; end

  def show
    @match = Matches.find_by(match_id: params[:id])
    @pl_match = PlMatch.where(match_id: params[:id])
    @pl_statistics = PlStat.where(match_id: params[:id])

    @players = []
    @pl_match.each do |pl_match|
      player = Player.find_by(id: pl_match.player_id)
      @players << player if player
    end
  end

  def match_multiple
    match = Matches.new
    match.match_engine(params)

    redirect_to fixtures_path
  end
end
class TurnReportController < ApplicationController
  def index
    @weeks = Match.all.map(&:week_number).uniq.sort
    @gm_messages = Message.where(var2: 'gm', week: params[:week_number])
    @public_messages = Message.where(var2: 'public', week: params[:week_number])
    @game_messages = Message.where(var2: 'game', week: params[:week_number])
    @week_premier_results = Match.where(week_number: params[:week_number], competition: 'Premier League')
    @week_championship_results = Match.where(week_number: params[:week_number], competition: 'Championship')
    @week_premier_fixtures = Fixture.where(week_number: params[:week_number].to_i + 1, comp: 'Premier League')
    @week_championship_fixtures = Fixture.where(week_number: params[:week_number].to_i + 1, comp: 'Championship')

    @premier_table = League.where(competition: 'Premier League').order(points: :desc, goal_difference: :desc, goals_for: :desc)
    @championship_table = League.where(competition: 'Championship').order(points: :desc, goal_difference: :desc, goals_for: :desc)

    @transfers = Transfer.where(week: params[:week_number]).order('player_id')

    @injured = Player.where.not(available: 0).order('club_id')
  end
end

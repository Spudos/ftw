class EndOfTurnJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      turn = Turn.find_by(week: params)

      league = League.new
      league.create_tables(turn)

      player = Player.new
      player.process_player_updates(params, turn)

      transfer = Transfer.new
      transfer.process_transfer_updates(params, turn)

      club = Club.new
      club.process_upgrade_admin(params, turn)
      club.process_club_updates(params, turn)
      club.process_squad_corrections(turn)

      article = Article.new
      article.process_article_updates(params, turn)
    rescue StandardError => e
      Error.create(
        error_type: 'EndOfTurnJob',
        message: e.message
      )
    end
  end
end

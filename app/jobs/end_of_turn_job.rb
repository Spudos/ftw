class EndOfTurnJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      Processing.create(message: "#{params}ET")
      league = League.new
      league.create_tables(params)

      turn = Turn.new
      turn.process_player_updates(params)

      turn.process_upgrade_admin(params)

      turn.process_club_updates(params)

      turn.process_article_updates(params)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      puts "ERROR: An error occurred while processing the job: #{e.message}"
    end
  end
end

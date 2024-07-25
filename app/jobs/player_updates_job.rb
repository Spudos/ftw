class PlayerUpdatesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      player = Player.new
      player.process_player_updates(params)
    rescue StandardError => e
      Error.create(
        error_type: 'PlayerUpdatesJob',
        message: e.message
      )
    end
  end
end

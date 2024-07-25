class ClubUpdatesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      club = Club.new
      club.process_club_updates(params)
    rescue StandardError => e
      Error.create(
        error_type: 'ClubUpdatesJob',
        message: e.message
      )
    end
  end
end

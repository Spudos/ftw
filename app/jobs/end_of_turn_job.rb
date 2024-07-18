class EndOfTurnJob < ApplicationJob
  queue_as :default

  def perform(params)
    CreateLeagueTablesJob.perform_later(params)
    PlayerUpdatesJob.perform_later(params)
    UpgradeAdminJob.perform_later(params)
    ClubUpdatesJob.perform_later(params)
    ArticleUpdatesJob.perform_later(params)

    Processing.create(message: "#{params}ET")
  end
end

class RunMatchesJob < ApplicationJob
  queue_as :default

  def perform(selected_week, competition)
    begin
      match = Match.new
      match.run_matches(selected_week, competition)
      Message.create(action_id: "#{params[:week]}COMPLETE-STEP3", week: params[:week], club_id: '999', var1: "week #{params[:week]} fixtures processed")
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
    end
  end
end

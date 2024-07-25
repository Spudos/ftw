class MatchesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      turn = Turn.find_by(week: params)

      selection = Selection.new
      selection.auto_selection(params, turn)

      match = Match.new
      match.run_matches(params, nil, turn)
    rescue StandardError => e
      Error.create(
        error_type: 'MatchesJob',
        message: e.message
      )
    end
  end
end

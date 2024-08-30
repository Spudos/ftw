class Match < ApplicationRecord
  has_many :home_teams, class_name: 'Clubs', foreign_key: 'home_team_id'
  has_many :away_teams, class_name: 'Clubs', foreign_key: 'home_team_id'

  def run_matches(selected_week, competition, turn)
    return if turn.run_matches

    fixture_list, selection, tactic = initialize_match(selected_week, competition)
    selection_complete, fixture_attendance = initialize_player(selection, tactic, fixture_list)
    summary = minute_by_minute(fixture_attendance, selection_complete, tactic)
    match_end(fixture_attendance, selection_complete, tactic, summary)

    turn.update(run_matches: true)
  end

  private

  def initialize_match(selected_week, competition)
    fixture_list = \
      Match::InitializeMatch::GetFixture.new(selected_week, competition).call
    selection = \
      Match::InitializeMatch::GetSelection.new(fixture_list).call
    tactic = \
      Match::InitializeMatch::GetTactic.new(fixture_list).call

    return fixture_list, selection, tactic
  end

  def initialize_player(selection, tactic, fixture_list)
    selection_performance = \
      Match::InitializePlayer::SelectionPerformance.new(selection).call
    selection_tactic = \
      Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call
    selection_star = \
      Match::InitializePlayer::SelectionStar.new(selection_tactic).call
    selection_stadium, fixture_attendance = \
      Match::InitializePlayer::SelectionStadium.new(selection_star, fixture_list).call
    selection_complete = \
      Match::InitializePlayer::SelectionAggression.new(selection_stadium, tactic).call

    return selection_complete, fixture_attendance
  end

  def minute_by_minute(fixture_attendance, selection_complete, tactic)
    summary = []
    chance_factor = GameParam.first.chance_factor
    midfield_on_attack = GameParam.first.midfield_on_attack
    target_factor = GameParam.first.target_factor
    goal_factor = GameParam.first.goal_factor

    rand(90..98).times do |i|
      selection_match, minute_by_minute_blend = Match::MinuteByMinute::MinuteByMinuteBlend.new(selection_complete).call

      all_teams = Match::MinuteByMinute::MinuteByMinuteTeams.new(selection_match, fixture_attendance).call

      all_teams.each do |match_team|
        minute_by_minute_press = \
          Match::MinuteByMinute::MinuteByMinutePress.new(match_team, tactic, i).call
        minute_by_minute_chance = \
          Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i, chance_factor).call
        minute_by_minute_target = \
          Match::MinuteByMinute::MinuteByMinuteTarget.new(minute_by_minute_chance, minute_by_minute_press, midfield_on_attack, target_factor).call
        minute_by_minute_scored = \
          Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, minute_by_minute_press, goal_factor).call
        minute_by_minute_names = \
          Match::MinuteByMinute::MinuteByMinuteNames.new(minute_by_minute_scored, selection_complete, match_team).call
        minute = [i,
                  match_team,
                  minute_by_minute_blend,
                  minute_by_minute_press,
                  minute_by_minute_chance,
                  minute_by_minute_target,
                  minute_by_minute_scored,
                  minute_by_minute_names]

        summary << minute
      end
    end

    Match::MinuteByMinute::MinuteByMinuteLogging.new(summary).call

    summary
  end

  def match_end(fixture_attendance, selection_complete, tactic, summary)
    match_summaries = Match::MatchEnd::MatchEndParse.new(summary).call
    Match::MatchEnd::MatchEndMatch.new(fixture_attendance, selection_complete, tactic, match_summaries).call
    Match::MatchEnd::MatchEndGoal.new(fixture_attendance, summary).call
    Match::MatchEnd::MatchEndPerformance.new(fixture_attendance, selection_complete).call
    Match::MatchEnd::MatchEndCommentary.new(fixture_attendance, summary, selection_complete).call
    Match::MatchEnd::MatchEndFitness.new(selection_complete, tactic).call
  end
end

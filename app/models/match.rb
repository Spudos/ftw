require 'benchmark'

class Match < ApplicationRecord
  has_many :home_teams, class_name: 'Clubs', foreign_key: 'home_team_id'
  has_many :away_teams, class_name: 'Clubs', foreign_key: 'home_team_id'

  def run_matches(selected_week, competition, turn)
    result = Benchmark.bm do |x|
      x.report('RunMatches') do
        return if turn.run_matches

        fixture_list, selection, tactic = initialize_match(selected_week, competition)
        selection_complete, fixture_attendance = initialize_player(selection, tactic, fixture_list)
        summary = minute_by_minute(fixture_attendance, selection_complete, tactic)
        match_end(fixture_attendance, selection_complete, tactic, summary)

        turn.update(run_matches: true)
      end
    end

    File.open('measurement-full_match.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{sprintf('%.6f', r.total)} seconds")
      end
    end
  end

  private

  def initialize_match(selected_week, competition)
    fixture_list = nil
    selection = nil
    tactic = nil

    result = Benchmark.bm do |x|
      x.report('GetFixture') do
        fixture_list = \
          Match::InitializeMatch::GetFixture.new(selected_week, competition).call
      end
      x.report('GetSelection') do
        selection = \
          Match::InitializeMatch::GetSelection.new(fixture_list).call
      end
      x.report('GetTactic') do
        tactic = \
          Match::InitializeMatch::GetTactic.new(fixture_list).call
      end
    end

    File.open('measurement-initialize_match.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{sprintf('%.6f', r.total)} seconds")
      end
    end

    return fixture_list, selection, tactic
  end

  def initialize_player(selection, tactic, fixture_list)
    selection_performance = nil
    selection_tactic = nil
    selection_star = nil
    selection_stadium = nil
    fixture_attendance = nil
    selection_complete = nil

    result = Benchmark.bm do |x|
      x.report('selection_performance') do
      selection_performance = \
        Match::InitializePlayer::SelectionPerformance.new(selection).call
      end

      x.report('selection_tactic') do
      selection_tactic = \
        Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call
      end

      x.report('selection_star') do
      selection_star = \
        Match::InitializePlayer::SelectionStar.new(selection_tactic).call
      end

      x.report('selection_stadium') do
      selection_stadium, fixture_attendance = \
        Match::InitializePlayer::SelectionStadium.new(selection_star, fixture_list).call
      end

      x.report('selection_complete') do
      selection_complete = \
        Match::InitializePlayer::SelectionAggression.new(selection_stadium, tactic).call
      end
    end

    File.open('measurement-initialize_player.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{sprintf('%.6f', r.total)} seconds")
      end
    end

    return selection_complete, fixture_attendance
  end

  def minute_by_minute(fixture_attendance, selection_complete, tactic)
    summary = []

    result = Benchmark.bm do |x|
      x.report('all_matches') do
        rand(90..98).times do |i|
          selection_match, minute_by_minute_blend = Match::MinuteByMinute::MinuteByMinuteBlend.new(selection_complete).call

          all_teams = Match::MinuteByMinute::MinuteByMinuteTeams.new(selection_match, fixture_attendance).call

          all_teams.each do |match_team|
            minute_by_minute_press = \
              Match::MinuteByMinute::MinuteByMinutePress.new(match_team, tactic, i).call
            minute_by_minute_chance = \
              Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i).call
            minute_by_minute_target = \
              Match::MinuteByMinute::MinuteByMinuteTarget.new(minute_by_minute_chance, match_team).call
            minute_by_minute_scored = \
              Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, match_team).call
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
      end
    end

    
      Match::MinuteByMinute::MinuteByMinuteLogging.new(summary).call
    

    File.open('measurement-minute_by_minute.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{sprintf('%.6f', r.total)} seconds")
      end
    end

    summary
  end

  def match_end(fixture_attendance, selection_complete, tactic, summary)
    match_summaries = nil

    result = Benchmark.bm do |x|
      x.report('MatchEndParse') do
        match_summaries = Match::MatchEnd::MatchEndParse.new(summary).call
      end

      x.report('MatchEndMatch') do
        Match::MatchEnd::MatchEndMatch.new(fixture_attendance, selection_complete, tactic, match_summaries).call
      end

      x.report('MatchEndGoal') do
        Match::MatchEnd::MatchEndGoal.new(fixture_attendance, summary).call
      end

      x.report('MatchEndPerformance') do
        Match::MatchEnd::MatchEndPerformance.new(fixture_attendance, selection_complete).call
      end

      x.report('MatchEndCommentary') do
        Match::MatchEnd::MatchEndCommentary.new(fixture_attendance, summary, selection_complete).call
      end

      x.report('MatchEndFitness') do
        Match::MatchEnd::MatchEndFitness.new(selection_complete, tactic).call
      end
    end

    File.open('match_end.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{sprintf('%.6f', r.total)} seconds")
      end
    end
  end
end
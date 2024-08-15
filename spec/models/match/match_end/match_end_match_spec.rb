require 'rails_helper'
require 'pry'

RSpec.describe Match::MatchEnd::MatchEndMatch, type: :model do
  describe 'saves the match data' do
    it 'from all current data' do
      fixture_attendance = [{ id: 1, club_home: '1', club_away: '2',
                              week_number: 1, competition: 'Premier League', attendance: 10_000 },
                            { id: 2, club_home: '3', club_away: '4',
                              week_number: 1, competition: 'Premier League', attendance: 10_000 }]

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 58 },
                            { club_id: '1', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 54 },
                            { club_id: '1', player_id: 7, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 56 },
                            { club_id: '1', player_id: 8, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 9, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 7, star: 20, fitness: 90, performance: 51 },
                            { club_id: '1', player_id: 10, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 11, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 59 },
                            { club_id: '2', player_id: 12, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 10, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 13, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 52 },
                            { club_id: '2', player_id: 14, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 8, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 15, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 54 },
                            { club_id: '2', player_id: 16, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 55 },
                            { club_id: '2', player_id: 17, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 2, star: 20, fitness: 90, performance: 56 },
                            { club_id: '2', player_id: 18, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 57 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 40 },
                            { club_id: '2', player_id: 20, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 30 },
                            { club_id: '2', player_id: 21, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 32 },
                            { club_id: '3', player_id: 22, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '3', player_id: 23, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '3', player_id: 24, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 58 },
                            { club_id: '3', player_id: 25, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 53 },
                            { club_id: '3', player_id: 26, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '3', player_id: 27, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 54 },
                            { club_id: '3', player_id: 28, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 56 },
                            { club_id: '3', player_id: 29, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 52 },
                            { club_id: '3', player_id: 30, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 7, star: 20, fitness: 90, performance: 51 },
                            { club_id: '3', player_id: 31, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 53 },
                            { club_id: '3', player_id: 32, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 59 },
                            { club_id: '4', player_id: 33, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 10, star: 20, fitness: 90, performance: 50 },
                            { club_id: '4', player_id: 34, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 52 },
                            { club_id: '4', player_id: 35, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 8, star: 20, fitness: 90, performance: 53 },
                            { club_id: '4', player_id: 36, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 54 },
                            { club_id: '4', player_id: 37, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 55 },
                            { club_id: '4', player_id: 38, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 2, star: 20, fitness: 90, performance: 56 },
                            { club_id: '4', player_id: 39, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 57 },
                            { club_id: '4', player_id: 40, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 53 },
                            { club_id: '4', player_id: 41, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 40 },
                            { club_id: '4', player_id: 42, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 30 },
                            { club_id: '4', player_id: 43, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 32 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 },
                { club_id: '2', tactic: 2, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 },
                { club_id: '3', tactic: 1, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 },
                { club_id: '4', tactic: 2, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 }]

      match_summaries = [{ home_club: '1',
                           away_club: '2',
                           dfc_blend_home: 2,
                           mid_blend_home: 3,
                           att_blend_home: 8,
                           dfc_blend_away: 1,
                           mid_blend_away: 4,
                           att_blend_away: 5,
                           home_possession: 75,
                           away_possession: 25,
                           home_chance: 10,
                           away_chance: 5,
                           home_target: 5,
                           away_target: 2,
                           home_goals: 2,
                           away_goals: 0 },
                         { home_club: '3',
                           away_club: '4',
                           dfc_blend_home: 2,
                           mid_blend_home: 3,
                           att_blend_home: 8,
                           dfc_blend_away: 1,
                           mid_blend_away: 4,
                           att_blend_away: 5,
                           home_possession: 75,
                           away_possession: 25,
                           home_chance: 10,
                           away_chance: 5,
                           home_target: 5,
                           away_target: 2,
                           home_goals: 2,
                           away_goals: 0 }]

      Match::MatchEnd::MatchEndMatch.new(fixture_attendance, selection_complete, tactic, match_summaries).call

      match = Match.first

      expect(match.home_team).to eq('1')
      expect(match.tactic_home).to eq(1)
      expect(match.dfc_blend_home).to eq(2)
      expect(match.mid_blend_home).to eq(3)
      expect(match.att_blend_home).to eq(8)
      expect(match.dfc_aggression_home).to eq(6)
      expect(match.mid_aggression_home).to eq(6)
      expect(match.att_aggression_home).to eq(6)
      expect(match.home_press).to eq(6)
      expect(match.away_team).to eq('2')
      expect(match.tactic_away).to eq(2)
      expect(match.dfc_blend_away).to eq(1)
      expect(match.mid_blend_away).to eq(4)
      expect(match.att_blend_away).to eq(5)
      expect(match.dfc_aggression_away).to eq(6)
      expect(match.mid_aggression_away).to eq(6)
      expect(match.att_aggression_away).to eq(6)
      expect(match.away_press).to eq(6)
      expect(match.home_possession).to eq(75)
      expect(match.away_possession).to eq(25)
      expect(match.home_chance).to eq(10)
      expect(match.away_chance).to eq(5)
      expect(match.home_chance_on_target).to eq(5)
      expect(match.away_chance_on_target).to eq(2)
      expect(match.home_goals).to eq(2)
      expect(match.away_goals).to eq(0)
      expect(match.attendance).to eq(10_000)
      expect(match.week_number).to eq(1)
      expect(match.competition).to eq('Premier League')
      expect(Match.count).to eq(2)
    end
  end
end

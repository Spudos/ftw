require 'rails_helper'
require 'pry'

RSpec.describe Match::MatchEnd::MatchEndParse, type: :model do
  describe 'takes the summary and creates useable summaries' do
    it 'from all current data' do
      summary = [[0,
                  [{ club_id: '1', defense: 170, midfield: 281, attack: 78 },
                   { club_id: '2', defense: 174, midfield: 204, attack: 59 }],
                  [{ club_id: '1', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '2', dfc_blend: 1, mid_blend: 4, att_blend: 5 }], 
                  [{ club_id: '1', defense_press: 170, midfield_press: 317, attack_press: 114 },
                   { club_id: '2', defense_press: 174, midfield_press: 204, attack_press: 59 }],
                  { chance: 113, team_chance_roll: 62, random_chance_roll: 41, chance_outcome: 'none' },
                  { on_target_home: 26, on_target_away: 20, on_target_roll: 78, chance_on_target: 'none' },
                  { goal_home: 17, goal_away: 13, goal_roll: 13, goal_scored: 'none' },
                  { assist: 'none', scorer: 'none' }],
                 [0,
                  [{ club_id: '3', defense: 195, midfield: 225, attack: 71 },
                   { club_id: '4', defense: 166, midfield: 212, attack: 73 }],
                  [{ club_id: '3', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '4', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '3', defense_press: 195, midfield_press: 261, attack_press: 107 },
                   { club_id: '4', defense_press: 166, midfield_press: 212, attack_press: 73 }],
                  { chance: 49, team_chance_roll: 40, random_chance_roll: 25, chance_outcome: 'none' },
                  { on_target_home: 25, on_target_away: 22, on_target_roll: 23, chance_on_target: 'none' },
                  { goal_home: 17, goal_away: 14, goal_roll: 17, goal_scored: 'none' },
                  { assist: 'none', scorer: 'none' }],
                 [1,
                  [{ club_id: '1', defense: 170, midfield: 281, attack: 78 },
                   { club_id: '2', defense: 174, midfield: 204, attack: 59 }],
                  [{ club_id: '1', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '2', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '1', defense_press: 170, midfield_press: 317, attack_press: 114 },
                   { club_id: '2', defense_press: 174, midfield_press: 204, attack_press: 59 }],
                  { chance: 113, team_chance_roll: 62, random_chance_roll: 41, chance_outcome: 'home' },
                  { on_target_home: 26, on_target_away: 20, on_target_roll: 78, chance_on_target: 'none' },
                  { goal_home: 17, goal_away: 13, goal_roll: 13, goal_scored: 'none' },
                  { assist: 'none', scorer: 'none' }],
                 [1,
                  [{ club_id: '3', defense: 195, midfield: 225, attack: 71 },
                   { club_id: '4', defense: 166, midfield: 212, attack: 73 }],
                  [{ club_id: '3', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '4', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '3', defense_press: 195, midfield_press: 261, attack_press: 107 },
                   { club_id: '4', defense_press: 166, midfield_press: 212, attack_press: 73 }],
                  { chance: 49, team_chance_roll: 40, random_chance_roll: 25, chance_outcome: 'away' },
                  { on_target_home: 25, on_target_away: 22, on_target_roll: 23, chance_on_target: 'none' },
                  { goal_home: 17, goal_away: 14, goal_roll: 17, goal_scored: 'none' },
                  { assist: 'none', scorer: 'none' }],
                 [2,
                  [{ club_id: '1', defense: 170, midfield: 281, attack: 78 },
                   { club_id: '2', defense: 174, midfield: 204, attack: 59 }],
                  [{ club_id: '1', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '2', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '1', defense_press: 170, midfield_press: 317, attack_press: 114 },
                   { club_id: '2', defense_press: 174, midfield_press: 204, attack_press: 59 }],
                  { chance: 113, team_chance_roll: 62, random_chance_roll: 41, chance_outcome: 'home' },
                  { on_target_home: 26, on_target_away: 20, on_target_roll: 78, chance_on_target: 'home' },
                  { goal_home: 17, goal_away: 13, goal_roll: 13, goal_scored: 'none' },
                  { assist: 'none', scorer: 'none' }],
                 [2,
                  [{ club_id: '3', defense: 195, midfield: 225, attack: 71 },
                   { club_id: '4', defense: 166, midfield: 212, attack: 73 }],
                  [{ club_id: '3', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '4', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '3', defense_press: 195, midfield_press: 261, attack_press: 107 },
                   { club_id: '4', defense_press: 166, midfield_press: 212, attack_press: 73 }],
                  { chance: 49, team_chance_roll: 40, random_chance_roll: 25, chance_outcome: 'away' },
                  { on_target_home: 25, on_target_away: 22, on_target_roll: 23, chance_on_target: 'away' },
                  { goal_home: 17, goal_away: 14, goal_roll: 17, goal_scored: 'away' },
                  { assist: 8, scorer: 11 }],
                 [3,
                  [{ club_id: '1', defense: 170, midfield: 281, attack: 78 },
                   { club_id: '2', defense: 174, midfield: 204, attack: 59 }],
                  [{ club_id: '1', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '2', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '1', defense_press: 170, midfield_press: 317, attack_press: 114 },
                   { club_id: '2', defense_press: 174, midfield_press: 204, attack_press: 59 }],
                  { chance: 113, team_chance_roll: 62, random_chance_roll: 41, chance_outcome: 'home' },
                  { on_target_home: 26, on_target_away: 20, on_target_roll: 78, chance_on_target: 'home' },
                  { goal_home: 17, goal_away: 13, goal_roll: 13, goal_scored: 'home' },
                  { assist: 2, scorer: 6 }],
                 [3,
                  [{ club_id: '3', defense: 195, midfield: 225, attack: 71 },
                   { club_id: '4', defense: 166, midfield: 212, attack: 73 }],
                  [{ club_id: '3', dfc_blend: 2, mid_blend: 3, att_blend: 8 },
                   { club_id: '4', dfc_blend: 1, mid_blend: 4, att_blend: 5 }],
                  [{ club_id: '3', defense_press: 195, midfield_press: 261, attack_press: 107 },
                   { club_id: '4', defense_press: 166, midfield_press: 212, attack_press: 73 }],
                  { chance: 49, team_chance_roll: 40, random_chance_roll: 25, chance_outcome: 'away' },
                  { on_target_home: 25, on_target_away: 22, on_target_roll: 23, chance_on_target: 'away' },
                  { goal_home: 17, goal_away: 14, goal_roll: 17, goal_scored: 'away' },
                  { assist: 8, scorer: 11 }]]

      allow_any_instance_of(Kernel).to receive(:rand).with(20..30).and_return(25)
      allow_any_instance_of(Kernel).to receive(:rand).with(70..80).and_return(75)

      match_summaries = Match::MatchEnd::MatchEndParse.new(summary).call

      expect(match_summaries[0][:home_club]).to eq('1')
      expect(match_summaries[0][:away_club]).to eq('2')
      expect(match_summaries[0][:dfc_blend_home]).to eq(2)
      expect(match_summaries[0][:mid_blend_home]).to eq(3)
      expect(match_summaries[0][:att_blend_home]).to eq(8)
      expect(match_summaries[0][:dfc_blend_away]).to eq(1)
      expect(match_summaries[0][:mid_blend_away]).to eq(4)
      expect(match_summaries[0][:att_blend_away]).to eq(5)
      expect(match_summaries[0][:home_possession]).to eq(75)
      expect(match_summaries[0][:away_possession]).to eq(25)
      expect(match_summaries[0][:home_chance]).to eq(3)
      expect(match_summaries[0][:away_chance]).to eq(0)
      expect(match_summaries[0][:home_target]).to eq(2)
      expect(match_summaries[0][:away_target]).to eq(0)
      expect(match_summaries[0][:home_goals]).to eq(1)
      expect(match_summaries[0][:away_goals]).to eq(0)
      expect(match_summaries[1][:home_club]).to eq('3')
      expect(match_summaries[1][:away_club]).to eq('4')
      expect(match_summaries[1][:home_possession]).to eq(25)
      expect(match_summaries[1][:away_possession]).to eq(75)
      expect(match_summaries[1][:home_chance]).to eq(0)
      expect(match_summaries[1][:away_chance]).to eq(3)
      expect(match_summaries[1][:home_target]).to eq(0)
      expect(match_summaries[1][:away_target]).to eq(2)
      expect(match_summaries[1][:home_goals]).to eq(0)
      expect(match_summaries[1][:away_goals]).to eq(2)
    end
  end
end

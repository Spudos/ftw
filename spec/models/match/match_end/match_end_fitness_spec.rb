require 'rails_helper'
require 'pry'

RSpec.describe Match::MatchEnd::MatchEndFitness do
  describe '#call' do
    it 'updates the fitness of players based on squads_performance and match_info' do
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
                            { club_id: '2', player_id: 22, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 32 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 6,
                  mid_aggression: 5, att_aggression: 4, press: 6 },
                { club_id: '2', tactic: 2, dfc_aggression: 3,
                  mid_aggression: 2, att_aggression: 1, press: 6 }]

      create(:club, id: 1)

      (1..22).each do |i|
        create(:player, id: i, fitness: 90)
      end

      allow_any_instance_of(Kernel).to receive(:rand).with(3..8).and_return(5)

      Match::MatchEnd::MatchEndFitness.new(selection_complete, tactic).call

      expect(Player.find(1).fitness).to eq(79)
      expect(Player.find(2).fitness).to eq(79)
      expect(Player.find(3).fitness).to eq(79)
      expect(Player.find(4).fitness).to eq(79)
      expect(Player.find(5).fitness).to eq(79)
      expect(Player.find(6).fitness).to eq(80)
      expect(Player.find(7).fitness).to eq(80)
      expect(Player.find(8).fitness).to eq(80)
      expect(Player.find(9).fitness).to eq(80)
      expect(Player.find(10).fitness).to eq(81)
      expect(Player.find(11).fitness).to eq(81)
      expect(Player.find(12).fitness).to eq(82)
      expect(Player.find(13).fitness).to eq(82)
      expect(Player.find(14).fitness).to eq(82)
      expect(Player.find(15).fitness).to eq(82)
      expect(Player.find(16).fitness).to eq(83)
      expect(Player.find(17).fitness).to eq(83)
      expect(Player.find(18).fitness).to eq(83)
      expect(Player.find(19).fitness).to eq(84)
      expect(Player.find(20).fitness).to eq(84)
      expect(Player.find(21).fitness).to eq(84)
      expect(Player.find(22).fitness).to eq(84)
    end
  end
end

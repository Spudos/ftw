require 'rails_helper'
require 'pry'

RSpec.describe Match::PlayerPerformance, type: :model do
  describe 'build the player array' do
    it 'should return the correct information' do
      player1 = build(:player)
      player2 = build(:player)
      match_squad = [player1, player2]

      players_array = Match::PlayerPerformance.new(match_squad).call

      expect(players_array[0][:player_id]).to eq(402)
      expect(players_array[0][:id]).to eq(nil)
      expect(players_array[0][:club]).to eq('001')
      expect(players_array[0][:player_name]).to eq('Woolley')
      expect(players_array[0][:total_skill]).to eq(85)
      expect(players_array[0][:tactic]).to eq(nil)
      expect(players_array[0][:player_position]).to eq('gkp')
      expect(players_array[0][:player_position_detail]).to eq('p')
      expect(players_array[0][:player_blend]).to eq(nil)
      expect(players_array[0][:star]).to eq(5)
      expect(players_array[0][:match_performance]).to be_between(0, 200).inclusive
      expect(players_array[1][:player_id]).to eq(403)
    end
  end
end
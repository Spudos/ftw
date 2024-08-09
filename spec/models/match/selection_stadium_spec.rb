require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionStadium, type: :model do
  describe 'stadium effect' do
    it 'should adjust the home totals based on a 9000 attendance' do
      selection_star = [{ club_id: '1', player_id: 1, name: 'woolley',
                          total_skill: 85, position: 'gkp', position_detail: 'p',
                          blend: 5, star: 20, fitness: 90, performance: 50 }]

      fixture_list = [{id: 1, club_home: '1', club_away: '2',
                       week_number: 1, competition: 'Premier League'}]

      selection_stadium = Match::InitializePlayer::SelectionStadium.new(selection_star, fixture_list).call

      expect(selection_stadium[0][:defense]).to eq(200)
      expect(selection_stadium[0][:midfield]).to eq(150)
      expect(selection_stadium[0][:attack]).to eq(125)
      expect(selection_stadium[1][:defense]).to eq(100)
      expect(selection_stadium[1][:midfield]).to eq(100)
      expect(selection_stadium[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 15000 stadium size' do
      attendance_size = 15_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(202)
      expect(stadium_effect[0][:midfield]).to eq(152)
      expect(stadium_effect[0][:attack]).to eq(127)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 25000 stadium size' do
      attendance_size = 25_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(205)
      expect(stadium_effect[0][:midfield]).to eq(155)
      expect(stadium_effect[0][:attack]).to eq(130)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 35000 stadium size' do
      attendance_size = 35_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(208)
      expect(stadium_effect[0][:midfield]).to eq(158)
      expect(stadium_effect[0][:attack]).to eq(133)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 45000 stadium size' do
      attendance_size = 45_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(210)
      expect(stadium_effect[0][:midfield]).to eq(160)
      expect(stadium_effect[0][:attack]).to eq(135)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 55000 stadium size' do
      attendance_size = 55_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(212)
      expect(stadium_effect[0][:midfield]).to eq(162)
      expect(stadium_effect[0][:attack]).to eq(137)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 65000 stadium size' do
      attendance_size = 65_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(215)
      expect(stadium_effect[0][:midfield]).to eq(165)
      expect(stadium_effect[0][:attack]).to eq(140)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end

    it 'should adjust the home totals based on a 100000 stadium size' do
      attendance_size = 100_000
      totals_blend = [
        {
          team: 1,
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: 2,
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, attendance_size).call

      expect(stadium_effect[0][:defense]).to eq(220)
      expect(stadium_effect[0][:midfield]).to eq(170)
      expect(stadium_effect[0][:attack]).to eq(145)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end
  end
end

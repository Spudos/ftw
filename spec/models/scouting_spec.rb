require 'rails_helper'
require 'pry'

RSpec.describe TurnActions, type: :model do
  describe 'scout for a player' do
    context 'with all player criteria' do
      before do
        create(:club, id: 1, managed: true)
        create(:club, id: 2, managed: false)

        create(:player, name: 'Normal GKP', position: 'gkp', club_id: 2, age: 45, loyalty: 80)
        create(:player, position: 'gkp', club_id: 2, age: 25, loyalty: 10,
                        name: 'Star GK',
                        control: 8,
                        tackling: 8,
                        shooting: 8,
                        offensive_heading: 8,
                        potential_control: 12,
                        potential_tackling: 12,
                        potential_shooting: 12,
                        potential_offensive_heading: 12,
                        total_skill: 100,
                        consistency: 3,
                        recovery: 10,
                        star: 25)
        create(:player, name: 'Normal DFC', position: 'dfc', club_id: 2, age: 45, loyalty: 80)
        create(:player, position: 'dfc', club_id: 2, age: 25, loyalty: 10,
                        name: 'Star DFC',
                        tackling: 8,
                        running: 8,
                        defensive_heading: 8,
                        strength: 8,
                        potential_tackling: 12,
                        potential_running: 12,
                        potential_defensive_heading: 12,
                        potential_strength: 12,
                        total_skill: 100,
                        consistency: 3,
                        recovery: 10,
                        star: 25)
        create(:player, name: 'Normal MID', position: 'mid', club_id: 2, age: 45, loyalty: 80)
        create(:player, position: 'mid', club_id: 2, age: 25, loyalty: 10,
                        name: 'Star MID',
                        passing: 8,
                        control: 8,
                        dribbling: 8,
                        creativity: 8,
                        potential_passing: 12,
                        potential_control: 12,
                        potential_dribbling: 12,
                        potential_creativity: 12,
                        total_skill: 100,
                        consistency: 3,
                        recovery: 10,
                        star: 25)
        create(:player, name: 'Normal ATT', position: 'att', club_id: 2, age: 45, loyalty: 80)
        create(:player, position: 'att', club_id: 2, age: 25, loyalty: 10,
                        name: 'Star ATT',
                        running: 8,
                        shooting: 8,
                        offensive_heading: 8,
                        flair: 8,
                        potential_running: 12,
                        potential_shooting: 12,
                        potential_offensive_heading: 12,
                        potential_flair: 12,
                        total_skill: 100,
                        consistency: 3,
                        recovery: 10,
                        star: 25)
      end

      it 'should return either gkp' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 50,
                       age: 50,
                       skills: false,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(['Star GK', 'Normal GKP']).to include(Message.last&.var2)
      end

      it 'should return either dfc' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'dfc',
                       total_skill: 50,
                       age: 50,
                       skills: false,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(['Star DFC', 'Normal DFC']).to include(Message.last&.var2)
      end

      it 'should return either mid' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'mid',
                       total_skill: 50,
                       age: 50,
                       skills: false,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(['Star MID', 'Normal MID']).to include(Message.last&.var2)
      end

      it 'should return either att' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'att',
                       total_skill: 50,
                       age: 50,
                       skills: false,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(['Star ATT', 'Normal ATT']).to include(Message.last&.var2)
      end

      it 'based on TS should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 50,
                       skills: false,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: false,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: false,
                       potential_skill: false,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills/loyalty should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: nil,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills/loyalty/potential_skill should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency/recovery should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: true,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency/recovery/star should return the Star GKP' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star GK')
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency/recovery/star should return the Star DFC' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'dfc',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star DFC')
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency/recovery/star should return the Star MID' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'mid',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star MID')
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency/recovery/star should return the Star ATT' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'att',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var2).to eq('Star ATT')
      end

      it 'no player found' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'att',
                       total_skill: 120,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: true,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call

        expect(Message.last&.var1).to eq('0')
      end
    end
  end
end

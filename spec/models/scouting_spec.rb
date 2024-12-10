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
                        star: 25,
                        blend: 1)
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
                        star: 25,
                        blend: 5)
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
                        star: 25,
                        blend: 10)
        create(:player, id: 66, position: 'att', club_id: 1, age: 25, loyalty: 10,
                        name: 'Club ATT',
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
                        star: 25,
                        blend: 10)
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Normal GKP']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star DFC', 'Normal DFC']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star MID', 'Normal MID']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star ATT', 'Normal ATT']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star GK']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star DFC']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star MID']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star ATT']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
      end

      it 'based on TS/age/skills/loyalty/potential_skill/consistency/recovery/star/blend should return the Star ATT with a blend of 5' do
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
                       blend_player: 66 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star ATT']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
        expect(Message.last&.var3).to eq(10)
      end

      it 'based on TS/age/skills/loyalty/consistency/recovery/star/blend should return the Star ATT with a blend of 5' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'att',
                       total_skill: 90,
                       age: 26,
                       skills: true,
                       loyalty: true,
                       potential_skill: false,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend_player: 66 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star ATT']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
        expect(Message.last&.var3).to eq(10)
      end

      it 'based on TS/age/loyalty/consistency/recovery/star should return the Star ATT with a blend of 5' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'att',
                       total_skill: 90,
                       age: 26,
                       skills: false,
                       loyalty: true,
                       potential_skill: false,
                       consistency: true,
                       recovery: true,
                       star: true,
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star ATT']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
      end

      it 'based on TS/age/loyalty/consistency/star should return the Star ATT with a blend of 5' do
        scout_info = { week: 1,
                       club_id: 1,
                       position: 'att',
                       total_skill: 90,
                       age: 26,
                       skills: false,
                       loyalty: true,
                       potential_skill: false,
                       consistency: true,
                       recovery: false,
                       star: true,
                       blend_player: 0 }

        Scouting::Scouting.new(scout_info).call

        possible_messages = ['Star ATT']
        expect(possible_messages.any? { |msg| Message.last&.var1.include?(msg) }).to be true
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
                       blend_player: 66 }

        Scouting::Scouting.new(scout_info).call

        expect(Message.last&.var1).to eq('Despite their best efforts, the scouts could not find a suitable player for you to consider signing.')
      end
    end
  end
end

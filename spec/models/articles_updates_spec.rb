require 'rails_helper'
require 'pry'

RSpec.describe Article::ArticleUpdates, type: :model do
  let(:week) { 1 }
  describe 'player_top_performance' do
    it 'should select the highest performing 4 players and highlight the best one' do
      create(:club, id: 1, name: 'clubby')
      create(:club, id: 2, name: 'cluubby')
      create(:club, id: 3, name: 'cluuubby')
      create(:club, id: 4, name: 'cluuubby')
      create(:player, club_id: 1, average_performance: 60, name: 'John', total_goals: 100, total_assists: 10)
      create(:player, club_id: 1, average_performance: 50, name: 'Johnny', total_goals: 90, total_assists: 20)
      create(:player, club_id: 2, average_performance: 40, name: 'Jon', total_goals: 80, total_assists: 30)
      create(:player, club_id: 2, average_performance: 30, name: 'Jonny', total_goals: 70, total_assists: 40)
      create(:player, club_id: 3, average_performance: 20, name: 'Joh', total_goals: 60, total_assists: 50)
      create(:player, club_id: 3, average_performance: 10, name: 'Johhny', total_goals: 50, total_assists: 60)

      Article::ArticleUpdates.new(week).call

      expect(Article.first.article_type).to eq('Player')
    end
  end
end

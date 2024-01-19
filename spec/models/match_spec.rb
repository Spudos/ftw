require 'rails_helper'

RSpec.describe Match, type: :model do
  it 'should have a valid factory that returns the injected away team' do
    match = build(:match, away_team: '101')
    expect(match.home_team).to be == '001'
    expect(match.away_team).to be == '101'
  end

  it 'should have a valid factory that returns the default away team' do
    match = build(:match)
    expect(match.home_team).to be == '001'
    expect(match.away_team).to be == '002'
  end

  it 'should have a valid factory that returns the default away team' do
    match = build(:match)
    match1 = build(:match)
    expect(match.match_id).to eq(0)
    expect(match1.match_id).not_to eq('cat')
  end
end

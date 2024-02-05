class Match::PressingEffect
  attr_reader :final_team

  def initialize(final_team, i)
    @final_team = final_team
    @i = i
  end

  def call
    pressing = pressing_information
    if @i < 10
      multiplier = 6
    elsif @i < 20
      multiplier = 5
    elsif @i < 30
      multiplier = 4
    elsif @i < 40
      multiplier = 3
    elsif @i < 50
      multiplier = 2
    elsif @i < 60
      multiplier = 1
    elsif @i < 70
      multiplier = 0
    elsif @i < 80
      multiplier = -2
    elsif @i < 90
      multiplier = -4
    elsif @i < 100
      multiplier = -6
    end

    match_team = {
      team: final_team[0][:team],
      defense: final_team[0][:defense] + (pressing[:dfc_home_pressing] * multiplier),
      midfield: final_team[0][:midfield] + (pressing[:mid_home_pressing] * multiplier),
      attack: final_team[0][:attack] + (pressing[:att_home_pressing] * multiplier)
    },
    {
      team: final_team[1][:team],
      defense: final_team[1][:defense] + (pressing[:att_away_pressing] * multiplier),
      midfield: final_team[1][:midfield] + (pressing[:att_away_pressing] * multiplier),
      attack: final_team[1][:attack] + (pressing[:att_away_pressing] * multiplier)
    }

    return match_team
  end
end

private

def pressing_information
  {
    dfc_home_pressing: 0,
    mid_home_pressing: 0,
    att_home_pressing: 0,
    dfc_away_pressing: 0,
    mid_away_pressing: 0,
    att_away_pressing: 0
  }
end

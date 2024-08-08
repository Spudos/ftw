class Match::PressingEffect
  attr_reader :final_team

  def initialize(final_team, i)
    @final_team = final_team
    @i = i
  end

  def call
    pressing = press_information
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
      defense: final_team[0][:defense],
      midfield: final_team[0][:midfield] + (pressing[:home_press] * multiplier),
      attack: final_team[0][:attack] + (pressing[:home_press] * multiplier)
    },
    {
      team: final_team[1][:team],
      defense: final_team[1][:defense],
      midfield: final_team[1][:midfield] + (pressing[:away_press] * multiplier),
      attack: final_team[1][:attack] + (pressing[:away_press] * multiplier)
    }

    return match_team
  end

  private

  def press_information
    home_press = Tactic.find_by(club_id: final_team[0][:team])&.press
    away_press = Tactic.find_by(club_id: final_team[1][:team])&.press

    if home_press.nil?
      home_press = 0
    end

    if away_press.nil?
      away_press = 0
    end

    {
      home_press:,
      away_press:
    }
  end
end

class Turn::Engines::ClubFanHappinessMatch
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def process
    match_info = Match.where(week_number: week)

    match_info.each do |match|
      home_team = Club.find_by(id: match.home_team)
      away_team = Club.find_by(id: match.away_team)

      if match.home_goals > match.away_goals
        home_team.fan_happiness = home_team.fan_happiness + 9
        away_team.fan_happiness = away_team.fan_happiness - 5
      elsif match.home_goals < match.away_goals
        home_team.fan_happiness = home_team.fan_happiness - 5
        away_team.fan_happiness = away_team.fan_happiness + 9
      else
        home_team.fan_happiness = home_team.fan_happiness + 3
        away_team.fan_happiness = away_team.fan_happiness + 3
      end
      home_team.save
      away_team.save
    end
  end
end

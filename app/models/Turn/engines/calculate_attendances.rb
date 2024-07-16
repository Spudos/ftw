class Turn::Engines::CalculateAttendances
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def process
    update_matches
  end

  private

  def clubs
    @clubs = Club.where(id: home_games)
  end

  def home_games
    Match.where(week_number: week).pluck(:home_team)
  end

  def update_matches
    all_matches = Match.where(week_number: week).where(home_team: attendances.keys)

    all_matches.each do |match|
      match.attendance = attendances[match.home_team.to_i]
    end

    Match.upsert_all(all_matches.as_json) if all_matches.present?
  end

  def attendances
    @attendances ||= {}.tap do |match_attendance|
      clubs.each do |club|
        match_attendance[club.id] = calcualte_attendance(club)
      end
    end
  end

  def calcualte_attendance(club)
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    if club.fanbase > stadium_size
      attendance = (stadium_size * rand(0.9756..0.9923)).to_i
    else
      attendance = (club.fanbase * club.fan_happiness) / 100
    end
    attendance
  end
end

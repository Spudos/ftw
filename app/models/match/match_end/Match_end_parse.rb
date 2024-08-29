class Match::MatchEnd::MatchEndParse
  attr_reader :summary

  def initialize(summary)
    @summary = summary
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if summary.nil?

    sorted = summary.group_by { |element| element[1][0][:club_id] }

    build_match_summary(sorted)
  end

  private

  def build_match_summary(sorted)
    match_summaries = []

    sorted.each do |record|
      home_club = record[1][0][1][0][:club_id]
      away_club = record[1][0][1][1][:club_id]

      dfc_blend_home,
      mid_blend_home,
      att_blend_home,
      dfc_blend_away,
      mid_blend_away,
      att_blend_away = blend(record, home_club, away_club)

      home_chance, away_chance = chance_count(record)
      home_target, away_target = target_count(record)
      home_goals, away_goals = goal_count(record)
      home_possession, away_possession = possession_count(home_chance, away_chance, home_club, away_club)

      match_summaries << { home_club:,
                           away_club:,
                           dfc_blend_home:,
                           mid_blend_home:,
                           att_blend_home:,
                           dfc_blend_away:,
                           mid_blend_away:,
                           att_blend_away:,
                           home_possession:,
                           away_possession:,
                           home_chance:,
                           away_chance:,
                           home_target:,
                           away_target:,
                           home_goals:,
                           away_goals: }
    end

    return match_summaries
  end

  def blend(record, home_club, away_club)
    dfc_blend_home = 0
    mid_blend_home = 0
    att_blend_home = 0
    dfc_blend_away = 0
    mid_blend_away = 0
    att_blend_away = 0

    record[1].each do |element|
      home = element[2].find { |hash| hash[:club_id] == home_club }
      away = element[2].find { |hash| hash[:club_id] == away_club }

      dfc_blend_home = home[:dfc]
      mid_blend_home = home[:mid]
      att_blend_home = home[:att]
      dfc_blend_away = away[:dfc]
      mid_blend_away = away[:mid]
      att_blend_away = away[:att]
    end

    return dfc_blend_home, mid_blend_home, att_blend_home, dfc_blend_away, mid_blend_away, att_blend_away
  end

  def chance_count(record)
    home_chance = 0
    away_chance = 0

    record[1].each do |element|
      if element[4][:chance_outcome] == 'home'
        home_chance += 1
      elsif element[4][:chance_outcome] == 'away'
        away_chance += 1
      end
    end

    return home_chance, away_chance
  end

  def target_count(record)
    home_target = 0
    away_target = 0

    record[1].each do |element|
      if element[5][:chance_on_target] == 'home'
        home_target += 1
      elsif element[5][:chance_on_target] == 'away'
        away_target += 1
      end
    end

    return home_target, away_target
  end

  def goal_count(record)
    home_goals = 0
    away_goals = 0

    record[1].each do |element|
      if element[6][:goal_scored] == 'home'
        home_goals += 1
      elsif element[6][:goal_scored] == 'away'
        away_goals += 1
      end
    end

    return home_goals, away_goals
  end

  def possession_count(home_chance, away_chance, home_club, away_club)
    initial_home_possession = if home_chance.zero?
                                0
                              elsif away_chance.zero?
                                100
                              elsif home_chance == away_chance
                                rand(40..60)
                              else
                                (home_chance.to_f / (home_chance + away_chance) * 100).round(0)
                              end

    if initial_home_possession < 20
      home_possession = rand(20..30)
    elsif initial_home_possession > 80
      home_possession = rand(70..80)
    else
      home_possession = initial_home_possession
    end

    away_possession = 100 - home_possession

    write_to_file(home_chance, away_chance, home_club, away_club, home_possession, away_possession)

    return home_possession, away_possession
  end

  def write_to_file(home_chance, away_chance, home_club, away_club, home_possession, away_possession)
    data_to_write = "#{home_club} vs #{away_club} - " \
                    "Home Chance: #{home_chance}, Away Chance: #{away_chance} - " \
                    "Home Possession: #{home_possession}, Away_Possession: #{away_possession}\n"

    File.open('matches.txt', 'a') do |file|
      file.write(data_to_write)
    end
  end
end

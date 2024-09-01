class League < ApplicationRecord
  def create_tables(turn)
    League.delete_all

    teams = teams_from_matches
    calculate_and_save_tables(teams)

    turn.update(create_tables: true)
  end

  def teams_from_matches
    home = Match.pluck(:home_team).uniq
    away = Match.pluck(:away_team).uniq
    (home + away).uniq
  end

  def calculate_and_save_tables(teams)
    teams.each do |t|
      competition = Club.find_by(id: t)&.league
      name = Club.find_by(id: t)&.name

      record = {
        club_id: t,
        name:,
        played: 0,
        won: 0,
        drawn: 0,
        lost: 0,
        goals_for: 0,
        goals_against: 0,
        goal_difference: 0,
        points: 0,
        competition:
      }

      Match.where(home_team: t, competition: competition).or(Match.where(away_team: t, competition: competition)).each do |m|
        record[:played] += 1

        if m.home_team == t
          record[:goals_for] += m.home_goals
          record[:goals_against] += m.away_goals
        else
          record[:goals_for] += m.away_goals
          record[:goals_against] += m.home_goals
        end

        if m.home_team == t
          if m.home_goals > m.away_goals
            record[:won] += 1
            record[:points] += 3
          elsif m.home_goals == m.away_goals
            record[:drawn] += 1
            record[:points] += 1
          else
            record[:lost] += 1
          end
        else
          if m.away_goals > m.home_goals
            record[:won] += 1
            record[:points] += 3
          elsif m.away_goals == m.home_goals
            record[:drawn] += 1
            record[:points] += 1
          else
            record[:lost] += 1
          end
        end

        if m.home_team == t
          record[:goal_difference] += m.home_goals - m.away_goals
        else
          record[:goal_difference] += m.away_goals - m.home_goals
        end
      end
      league_record = League.new(record)
      league_record.save!
    end
  end

  def self.compile_biggest_stadiums(league)
    clubs = Club.where(league: league).map do |club|
      unless club.league == league
        next
      end
      {
        name: club.name,
        stadium_size: club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity
      }
    end

    clubs.compact!

    clubs.sort_by! { |club| -club[:stadium_size] }

    club_biggest_stadiums = clubs.take(10)
    return club_biggest_stadiums
  end

  def self.compile_biggest_fanbase(league)
    clubs = Club.where(league: league).map do |club|
      unless club.league == league
        next
      end
      {
        name: club.name,
        fanbase: club.fanbase
      }
    end

    clubs.compact!

    clubs.sort_by! { |club| -club[:fanbase] }

    club_biggest_fanbase = clubs.take(10)
    return club_biggest_fanbase
  end

  def self.compile_biggest_banks(league)
    clubs = Club.where(league: league).map do |club|
      unless club.league == league
        next
      end
      {
        name: club.name,
        bank: club.bank_bal
      }
    end

    clubs.compact!

    clubs.sort_by! { |club| -club[:bank] }

    club_biggest_banks = clubs.take(10)
    return club_biggest_banks
  end

  def self.compile_biggest_coaches(league)
    clubs = Club.where(league: league).map do |club|
      unless club.league == league
        next
      end
      {
        name: club.name,
        coaches: club.staff_gkp + club.staff_dfc + club.staff_mid + club.staff_att
      }
    end

    clubs.compact!

    clubs.sort_by! { |club| -club[:coaches] }

    club_biggest_coaches = clubs.take(10)
    return club_biggest_coaches
  end

  def self.compile_biggest_fitness(league)
    clubs = Club.where(league: league).map do |club|
      unless club.league == league
        next
      end
      {
        name: club.name,
        staff_fitness: club.staff_fitness
      }
    end

    clubs.compact!

    clubs.sort_by! { |club| -club[:staff_fitness] }

    club_biggest_fitness = clubs.take(10)
    return club_biggest_fitness
  end

  def self.compile_biggest_fan_happiness(league)
    clubs = Club.where(league: league).map do |club|
      unless club.league == league
        next
      end
      {
        name: club.name,
        fan_happiness: club.fan_happiness
      }
    end

    clubs.compact!

    clubs.sort_by! { |club| -club[:fan_happiness] }

    club_biggest_fan_happiness = clubs.take(10)
    return club_biggest_fan_happiness
  end
end

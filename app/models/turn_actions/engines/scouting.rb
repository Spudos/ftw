class TurnActions::Engines::Scouting
  attr_reader :scout_info

  def initialize(scout_info)
    @week = scout_info[:week]
    @club_id = scout_info[:club_id]
    @position = scout_info[:position]
    @total_skill = scout_info[:total_skill]
    @age = scout_info[:age]
    @skills = scout_info[:skills]
    @loyalty = scout_info[:loyalty]
    @potential_skill = scout_info[:potential_skill]
    @consistency = scout_info[:consistency]
    @recovery = scout_info[:recovery]
    @star = scout_info[:star]
    @blend_player = scout_info[:blend]
  end

  def call
    players = search_for_players

    players = secondary_filters(players)

    report_search_result(players.sample)
  end

  private

  def search_for_players
    Player.where('position = ? AND total_skill >= ? AND age <= ? AND loyalty <= ?
                 AND consistency <= ? AND recovery >= ? AND star >= ? ',
                 @position,
                 @total_skill,
                 @age,
                 loyalty,
                 consistency,
                 recovery,
                 star)
  end

  def loyalty
    if @loyalty == true
      20
    else
      100
    end
  end

  def consistency
    if @consistency == true
      5
    else
      100
    end
  end

  def recovery
    if @recovery == true
      8
    else
      0
    end
  end

  def star
    if @star == true
      20
    else
      0
    end
  end

  def secondary_filters(players)
    players = skill_search(players, 'normal', 7) if @skills == true

    players = skill_search(players, 'potential', 11) if @potential_skill == true

    return players
  end

  def skill_search(players, skill_type, min)
    players_with_skills = []

    players.each do |player|
      key_skills = send("#{skill_type}_positional_skills", player.position)

      next unless player[key_skills[0]] >= min &&
                  player[key_skills[1]] >= min &&
                  player[key_skills[2]] >= min &&
                  player[key_skills[3]] >= min

      players_with_skills << player
    end

    players_with_skills
  end

  def normal_positional_skills(pos)
    skills = {
      'gkp' => %w[control tackling shooting offensive_heading],
      'dfc' => %w[tackling running defensive_heading strength],
      'mid' => %w[passing control dribbling creativity],
      'att' => %w[running shooting offensive_heading flair]
    }
    skills[pos]
  end

  def potential_positional_skills(pos)
    skills = {
      'gkp' => %w[potential_control potential_tackling potential_shooting potential_offensive_heading],
      'dfc' => %w[potential_tackling potential_running potential_defensive_heading potential_strength],
      'mid' => %w[potential_passing potential_control potential_dribbling potential_creativity],
      'att' => %w[potential_running potential_shooting potential_offensive_heading potential_flair]
    }
    skills[pos]
  end

  def report_search_result(player)

    if player.nil?
      Message.create(week: @week,
                     club_id: @club_id,
                     var1: 0)
    else
      Message.create(week: @week,
                     club_id: @club_id,
                     var1: player.id,
                     var2: player.name,
                     var3: player.position)
    end
  end
end

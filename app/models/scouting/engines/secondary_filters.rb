class Scouting::Engines::SecondaryFilters
  attr_reader :players, :skills, :potential_skill

  def initialize(players, skills, potential_skill)
    @players = players
    @skills = skills
    @potential_skill = potential_skill
  end

  def call
    secondary_filters(players)
  end

  private

  def secondary_filters(players)
    players = skill_search(players, 'normal', 6) if @skills == true

    players = skill_search(players, 'potential', 9) if @potential_skill == true

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
end

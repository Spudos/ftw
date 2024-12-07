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

  def skills
    @skills
  end

  def loyalty
    if @loyalty == true
      20
    else
      100
    end
  end

  def potential_skill
    @potential_skill
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

  def blend_player
    @blend_player
  end

  def report_search_result(player)
    binding.pry
  end
end

class Scouting::Engines::SearchForPlayers
  attr_reader :scout_info

  def initialize(scout_info)
    @club_id = scout_info[:club_id]
    @position = scout_info[:position]
    @total_skill = scout_info[:total_skill]
    @age = scout_info[:age]
    @loyalty = scout_info[:loyalty]
    @consistency = scout_info[:consistency]
    @recovery = scout_info[:recovery]
    @star = scout_info[:star]
  end

  def call
    search_for_players
  end

  private

  def search_for_players
    Player.where('position = ? AND club_id != ? AND total_skill >= ? AND age <= ? AND loyalty <= ?
                 AND consistency <= ? AND recovery >= ? AND star >= ? ',
                 @position,
                 @club_id,
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
end

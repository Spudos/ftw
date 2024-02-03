class Match::TacticAdjustment
  # tactic name       dfc  mid  att  l,r  c
  # 1      passing    -5  +15  -5    0    0
  # 2      defensive  +15 -10  -10   0    0
  # 3      Attacking  -10 +5   +15   0    0
  # 4      Wide        0   0    0   +10  -10
  # 5      Narrow      0   0    0   -10  +10
  # 6      Direct     +5  -5   +5    0    0

  attr_reader :squad_performance

  def initialize(squad_performance)
    @squad_performance = squad_performance
  end

  def call
    if squad_performance.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end
    
    players = squad_performance

    players.each do |player|
      performance_by_position_detail(player)
      performance_by_position(player)
    end

    squads_with_adjusted_performance = players
  end

  def performance_by_position_detail(player)
    if player[:player_position_detail] == 'c'
      player[:match_performance] -= 10 if player[:tactic] == 4
      player[:match_performance] += 10 if player[:tactic] == 5
    elsif player[:player_position_detail] == 'r' || player[:player_position_detail] == 'l'
      player[:match_performance] += 10 if player[:tactic] == 4
      player[:match_performance] -= 10 if player[:tactic] == 5
    end
  end

  def performance_by_position(player)
    if player[:player_position] == 'dfc'
      player[:match_performance] -= 5 if player[:tactic] == 1
      player[:match_performance] += 15 if player[:tactic] == 2
      player[:match_performance] -= 10 if player[:tactic] == 3
      player[:match_performance] += 5 if player[:tactic] == 6
    elsif player[:player_position] == 'mid'
      player[:match_performance] += 15 if player[:tactic] == 1
      player[:match_performance] -= 10 if player[:tactic] == 2
      player[:match_performance] += 5 if player[:tactic] == 3
      player[:match_performance] -= 5 if player[:tactic] == 6
    elsif player[:player_position] == 'att'
      player[:match_performance] -= 5 if player[:tactic] == 1
      player[:match_performance] -= 10 if player[:tactic] == 2
      player[:match_performance] += 15 if player[:tactic] == 3
      player[:match_performance] += 5 if player[:tactic] == 6
    end
  end
end

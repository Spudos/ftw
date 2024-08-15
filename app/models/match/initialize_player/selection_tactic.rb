class Match::InitializePlayer::SelectionTactic
  # tactic name       dfc  mid  att  l,r  c
  # 1      passing    -5  +15  -5    0    0
  # 2      defensive  +15 -10  -10   0    0
  # 3      Attacking  -10 +5   +15   0    0
  # 4      Wide        0   0    0   +10  -10
  # 5      Narrow      0   0    0   -10  +10
  # 6      Direct     +5  -5   +5    0    0

  attr_reader :selection_performance, :tactic

  def initialize(selection_performance, tactic)
    @selection_performance = selection_performance
    @tactic = tactic
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if selection_performance.nil?

    selection_tactic = []

    selection_performance.each do |player|
      player_tactic = get_tactic(player[:club_id])

      player_positiion_detail = performance_by_position_detail(player, player_tactic)
      selection_tactic << performance_by_position(player_positiion_detail, player_tactic)
    end

    return selection_tactic
  end

  private

  def get_tactic(club)
    tactic.each do |tactic|
      return tactic[:tactic] if tactic[:club_id] == club
    end
  end

  def performance_by_position_detail(player, player_tactic)
    if player[:position_detail] == 'c'
      player[:performance] -= 10 if player_tactic == 4
      player[:performance] += 10 if player_tactic == 5
    elsif player[:position_detail] == 'r' || player[:position_detail] == 'l'
      player[:performance] += 10 if player_tactic == 4
      player[:performance] -= 10 if player_tactic == 5
    end

    player
  end

  def performance_by_position(player, player_tactic)
    if player[:position] == 'dfc'
      player[:performance] -= 5 if player_tactic == 1
      player[:performance] += 15 if player_tactic == 2
      player[:performance] -= 10 if player_tactic == 3
      player[:performance] += 5 if player_tactic == 6
    elsif player[:position] == 'mid'
      player[:performance] += 15 if player_tactic == 1
      player[:performance] -= 10 if player_tactic == 2
      player[:performance] += 5 if player_tactic == 3
      player[:performance] -= 5 if player_tactic == 6
    elsif player[:position] == 'att'
      player[:performance] -= 5 if player_tactic == 1
      player[:performance] -= 10 if player_tactic == 2
      player[:performance] += 15 if player_tactic == 3
      player[:performance] += 5 if player_tactic == 6
    end

    player
  end
end

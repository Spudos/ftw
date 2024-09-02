class TurnActions::Engines::Blend
  attr_reader :action_id, :week, :turn, :club_id, :position, :amount

  def initialize(action_id, week, turn, club_id, position, amount)
    @action_id = action_id
    @week = week
    @turn = turn
    @club_id = club_id
    @position = position
    @amount = amount
  end

  def call
    if rand(0..100) < 50
      blend_players
      success_message
    else
      failure_message
    end
    adjust_bank
  end

  private

  def blend_players
    players, highest_blend_player = filter_players

    average_blend = players.sum(&:blend) / players.count

    highest_blend_player.update(blend: new_blend(highest_blend_player.blend, average_blend))
  end

  def filter_players
    players = Player.where(club_id:, position:).order(blend: :asc)

    highest_blend_player = players.last
    players = players.where.not(id: highest_blend_player.id)

    return players, highest_blend_player
  end

  def new_blend(highest_blend, average_blend)
    highest_blend - (highest_blend - average_blend) / 2
  end

  def adjust_bank
    Turn::BankAdjustment.new(action_id, week, club_id, 'blend', position, amount).call
  end

  def failure_message
    Message.create(week:, club_id:, var1: "This week, you spent a significant amount on team building activities and extra training for your #{position} players. Despite the efforts of your staff, the blending process failed")
  end

  def success_message
    Message.create(week:, club_id:, var1: "This week, you spent a significant amount on team building activities and extra training for your #{position} players. The blending process was successful")
  end
end

class TurnActions::Engines::Blend
  attr_reader :action_id, :week, :turn, :club_id, :player_id, :amount, :blending_player

  def initialize(action_id, week, turn, club_id, player_id, amount)
    @action_id = action_id
    @week = week
    @turn = turn
    @club_id = club_id
    @player_id = player_id
    @amount = amount
    @blending_player = Player.find(player_id)
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
    players = Player.where(club_id:, position: blending_player.position).where.not(id: blending_player.id)

    if players.empty?
      failure_message
    else
      average_blend = players.sum(&:blend) / players.count

      blending_player.update(blend: adjusted_blend(average_blend))
    end
  end

  def adjusted_blend(average_blend)
    blending_player.blend - (blending_player.blend - average_blend) / 2
  end

  def adjust_bank
    Turn::BankAdjustment.new(action_id, week, club_id, 'blend', blending_player.position, amount).call
  end

  def failure_message
    Message.create(week:,
                   club_id:,
                   var1: "This week, you spent a significant amount on team building activities and extra training for your #{blending_player.position} players. Despite the efforts of your staff, the blending process failed")
  end

  def success_message
    Message.create(week:,
                   club_id:,
                   var1: "This week, you spent a significant amount on team building activities and extra training for your #{blending_player.position} players. The blending process was successful")
  end
end

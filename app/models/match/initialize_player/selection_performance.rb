class Match::InitializePlayer::SelectionPerformance
  attr_reader :selections

  def initialize(selections)
    @selections = selections
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selections.nil?

    selection_performance = []

    selections.each do |selection|
      player_id = selection[:player_id]
      player = player_data.find(player_id)

      selection_performance << hash(player, selection)
    end

    selection_performance
  end

  private

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end

  def hash(player, selection)
    { club_id: selection[:club_id],
      player_id: player.id,
      name: player.name,
      total_skill: player.total_skill,
      position: player.position,
      position_detail: player.player_position_detail,
      blend: player.blend,
      star: player.star,
      fitness: player.fitness,
      performance: player.match_performance(player) }
  end
end

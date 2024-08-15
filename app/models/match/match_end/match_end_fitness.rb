class Match::MatchEnd::MatchEndFitness
  attr_reader :selection_complete, :tactic

  def initialize(selection_complete, tactic)
    @selection_complete = selection_complete
    @tactic = tactic
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selection_complete.nil?

    Player.upsert_all(player_record)
  end

  private

  def player_record
    player_upload = []

    selection_complete.each do |player|
      tactic_record = tactic.find { |t| t[:club_id] == player[:club_id] }
      player_fitness = player[:fitness]

      player_fitness -= rand(3..8)

      if player[:position] == 'gkp' || player[:position] == 'dfc'
        player_fitness -= tactic_record[:dfc_aggression]
      elsif player[:position] == 'mid'
        player_fitness -= tactic_record[:mid_aggression]
      else
        player_fitness -= tactic_record[:att_aggression]
      end

      player_fitness = 10 if player_fitness < 10

      player_upload << { id: player[:player_id], fitness: player_fitness }
    end

    player_upload
  end
end

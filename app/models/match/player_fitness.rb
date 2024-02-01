class Match::PlayerFitness
  attr_reader :squads_with_performance, :match_info

  def initialize(squads_with_performance, match_info)
    @squads_with_performance = squads_with_performance
    @match_info = match_info
  end

  def call
    squads_with_performance.each do |player|
      player_record = Player.find_by(id: player[:player_id])
      player_fitness = player_record&.fitness
      player_fitness -= rand(3..8)

      if player[:player_position] == 'gkp' || player[:player_position] == 'dfc'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:dfc_aggression_home] * 2
        else
          player_fitness -= match_info[:dfc_aggression_away] * 2
        end
      elsif player[:player_position] == 'mid'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:mid_aggression_home] * 2
        else
          player_fitness -= match_info[:mid_aggression_away] * 2
        end
      else
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:att_aggression_home] * 2
        else
          player_fitness -= match_info[:att_aggression_away] * 2
        end
      end

      player_fitness = 50 if player_fitness < 50

      player_record.update(fitness: player_fitness) if player_record
    end
  end
end

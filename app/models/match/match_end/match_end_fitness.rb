class Match::InitializePlayer::SelectionFitness
  attr_reader :selection_star

  def initialize(selection_star, tactic)
    @selection_star = selection_star
    @tactic = tactic
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selection_star.nil?

    selection_star.each do |player|
binding.pry
      player_fitness -= rand(3..8)

      if player[:player_position] == 'gkp' || player[:player_position] == 'dfc'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:dfc_aggression_home]
        else
          player_fitness -= match_info[:dfc_aggression_away]
        end
      elsif player[:player_position] == 'mid'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:mid_aggression_home]
        else
          player_fitness -= match_info[:mid_aggression_away]
        end
      else
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:att_aggression_home]
        else
          player_fitness -= match_info[:att_aggression_away]
        end
      end

      player_fitness = 10 if player_fitness < 10

      player_record.update(fitness: player_fitness) if player_record
    end
  end
end

class Match::InitializePlayer::SelectionAggression
  attr_reader :selection_stadium, :tactic

  def initialize(selection_stadium, tactic)
    @selection_stadium = selection_stadium
    @tactic = tactic
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if selection_stadium.empty?

    selection_complete = []

    selection_stadium.each do |player|
      aggression = tactic.find { |hash| hash[:club_id] == player[:club_id] }
      case player[:position]
      when 'dfc'
        player[:performance] = player[:performance] + aggression[:dfc_aggression]
      when 'mid'
        player[:performance] = player[:performance] + aggression[:mid_aggression]
      when 'att'
        player[:performance] = player[:performance] + aggression[:att_aggression]
      end

      selection_complete << player
    end

    return selection_complete
  end
end

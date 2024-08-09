class Match::InitializePlayer::SelectionStar
  attr_reader :selection_tactic

  def initialize(selection_tactic)
    @selection_tactic = selection_tactic
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selection_tactic.nil?

    selection_star = []

    selection_tactic.each do |player|
      player[:performance] += player[:star] if rand(1..100) > 50
      selection_star << player
    end

    selection_star
  end
end

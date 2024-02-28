class Turn::Engines::Fitness
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    fitness_increase
  end

  private

  def fitness_increase
    players.each do |player|
      if player.fitness != 100
        player.fitness += rand(0..5)
        player.fitness = 100 if player.fitness > 100
      end
    end
  end
end

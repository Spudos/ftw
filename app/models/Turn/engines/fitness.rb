class Turn::Engines::Fitness
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    availability
    fitness_increase
    random_injury
    injury
  end

  private

  def availability
    players.each do |player|
      if player.available > 0
        player.available -= 1
        player.save
        if player.available == 0
        Message.create(week:, action_id: week.to_s + player.club_id.to_s + 'fitness' ,club_id: player.club_id, var1: "#{player.name} is now available for selection after injury")
        end
      end
    end
  end

  def fitness_increase
    players.each do |player|
      if player.fitness != 100
        player.fitness += rand(0..5)
        player.fitness = 100 if player.fitness > 100
        player.save
      end
    end
  end

  def random_injury
    players.each do |player|
      if rand(1..100) <= 2
        player.fitness -= rand(20..40)
        player.save
        Message.create(week:, action_id: week.to_s + player.club_id.to_s + 'fitness' ,club_id: player.club_id, var1: "#{player.name} took a bad knock in training this week")
      end
    end
  end

  def injury
    players.each do |player|
      if player.fitness < 60
        player.available = rand(1..6)
        player.save
        Message.create(week:, action_id: week.to_s + player.club_id.to_s + 'fitness' ,club_id: player.club_id, var1: "#{player.name} has been injured and will be out for #{player.available} weeks")
      end
    end
  end
end

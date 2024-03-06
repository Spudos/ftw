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
      if player.available.positive?
        player.available -= 1
        if player.available.zero?
          Message.create(week:,
                         action_id: "#{week}#{player.club_id}fitness",
                         club_id: player.club_id,
                         var1: "#{player.name} is now available for selection after injury")
        end
      end
    end
  end

  def fitness_increase
    players.each do |player|
      player.fitness += rand(0..5)
      player.fitness = 100 if player.fitness > 100
    end
  end

  def random_injury
    players.each do |player|
      if rand(1..100) <= 2
        player.fitness -= rand(20..40)
        Message.create(week:,
                       action_id: "#{week}#{player.club_id}fitness",
                       club_id: player.club_id,
                       var1: "#{player.name} took a bad knock in training this week")
      end
    end
  end

  def injury
    players.each do |player|
      if player.fitness < 60
        player.available = rand(1..9)
        Message.create(week:,
                       action_id: "#{week}#{player.club_id}fitness",
                       club_id: player.club_id,
                       var1: "#{player.name} has been injured and will be out for #{player.available} weeks")
        if Selection.exists?(player_id: player.id)
          Selection.find_by(player_id: player.id).destroy
        end
      end
    end
  end
end

class Turn::Engines::Fitness
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    sped_up_version
  end

  private

  def sped_up_version
    players.each do |player|
      availability(player)
      fitness_increase(player)
      random_injury(player)
      injury(player)
    end
  end

  def availability(player)
    return if player.available.negative?

    player.available -= 1

    return if player.available.positive?

    Message.create(week:,
                   action_id: "#{week}#{player.club_id}fitness",
                   club_id: player.club_id,
                   var1: "#{player.name} is now available for selection after injury")
  end

  def fitness_increase(player)
    player.fitness += rand(0..5)
    player.fitness = 100 if player.fitness > 100
  end

  def random_injury(player)
    return unless rand(1..100) <= 2

    player.fitness -= rand(20..40)
    Message.create(week:,
                   action_id: "#{week}#{player.club_id}fitness",
                   club_id: player.club_id,
                   var1: "#{player.name} took a bad knock in training this week")
  end

  def injury(player)
    return unless player.fitness < 60

    player.available = rand(1..9)
    Message.create(week:,
                   action_id: "#{week}#{player.club_id}fitness",
                   club_id: player.club_id,
                   var1: "#{player.name} has been injured and will be out for #{player.available} weeks")

    Selection.find_by(player_id: player.id).destroy if Selection.exists?(player_id: player.id)
  end
end

class Player::Engines::Fitness
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
    @fitness_messages = []
    @destroyable_player_ids = []
  end

  def process
    players.each do |player|
      fitness_increase(player)

      next unless player.club.managed?

      availability(player)
      random_injury(player)
      injury(player)
    end
    Message.insert_all(@fitness_messages) unless @fitness_messages.empty?
    destroy_selection
    players
  end

  private

  def fitness_increase(player)
    if player.club.managed?
      player.fitness += rand(0..5)
      player.fitness = 100 if player.fitness > 100
    else
      player.fitness = 100
    end
  end

  def availability(player)
    if player.available.positive?
      player.available -= 1
      if player.available.zero?
        @fitness_messages << {
          week:,
          action_id: "#{week}#{player.club_id}fitness",
          club_id: player.club_id,
          var1: "#{player.name} is now available for selection after injury"
        }
      end
    end
  end

  def random_injury(player)
    if rand(1..100) <= 2
      player.fitness -= rand(20..40)
      @fitness_messages << {
        week:,
        action_id: "#{week}#{player.club_id}fitness",
        club_id: player.club_id,
        var1: "#{player.name} took a bad knock in training this week"
      }
    end
  end

  def injury(player)
    if player.fitness < 60 && player.available.zero?
      player.available = rand(1..9)
      @fitness_messages << {
        week:,
        action_id: "#{week}#{player.club_id}fitness",
        club_id: player.club_id,
        var1: "#{player.name} has been injured and will be out for #{player.available} weeks"
      }

      @destroyable_player_ids << player.id if selections.select { |p| p.player_id == player.id }.present?
    end
  end

  def selections
    @selections ||= Selection.where(player_id: players.pluck(:id)).load
  end

  def destroy_selection
    Selection.where(player_id: @destroyable_player_ids).destroy_all
  end
end

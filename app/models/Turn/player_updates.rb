class Turn::PlayerUpdates
  attr_reader :week

  Rails.cache.clear

  def initialize(week)
    @week = week
  end

  def call
    process
    # fitness_increase
    # contract_decrease
    # player_value
    # player_wages
    # player_total_skill
    # player_games_played
    # player_total_goals
    # player_total_assists
    # player_average_perfomance
  end

  private

  def process
    functions = [:fitness_increase, :contract_decrease, :player_value, :player_wages, :player_total_skill, :player_games_played, :player_total_goals, :player_total_assists, :player_average_perfomance]
    # objects = [FitnessEngine, ContractEngine, PlayerEngine]

    player_data.in_batches do |batch|
      players = batch.load

      functions.each do |function|
        send(function, players)
      end

      # objects.each do |object|
      #   players = object.new(players).process
      # end

      # players.save
      attributes = players.to_a.map(&:as_json)
      Player.upsert_all(attributes)
    end
  end

  def fitness_increase(players)
    players.each do |player|
      if player.fitness != 100
        player.fitness += rand(0..5)
        player.fitness = 100 if player.fitness > 100
        # player.save
      end
    end
  end

  def contract_decrease(players)
    players.each do |player|
      if player.club.managed?
        player.contract -= 1
        # player.save

        if player.contract == 3 || player.contract < 1
          contract_action(player)
        end
      end
    end
  end

  def contract_action(player)
    if player.contract < 1
      Message.create(week:, club_id: player.club_id, var1: "#{player.name} has been released at the end of his contract with the club.")
      player.contract = 51
      player.club_id = 242
      # player.save
    else
      Message.create(week:, club_id: player.club_id, var1: "#{player.name} has only 3 weeks of his contract remaining.  When it reaches zero he will be released by the club.")
    end
  end

  def player_value(players)
    players.each do |player|
      if player.total_skill < 77
        player.value = player.total_skill * 259740
      elsif player.total_skill < 99
        player.value = player.total_skill * 505050
      elsif player.total_skill < 110
        player.value = player.total_skill * 772727
      else
        player.value = player.total_skill * 867546
      end

      # player.save
    end
  end

  def player_wages(players)
    players.each do |player|
      if player.total_skill < 77
        player.wages = player.total_skill * 845
      elsif player.total_skill < 99
        player.wages = player.total_skill * 2025
      elsif player.total_skill < 110
        player.wages = player.total_skill * 3287
      else
        player.wages = player.total_skill * 4181
      end

      # player.save
    end
  end

  def player_total_skill(players)
    players.each do |player|
      player.total_skill = player.total_skill

      # player.save
    end
  end

  def player_games_played(players)
    players.each do |player|
      performances = Performance.where(player_id: player.id)
      player.games_played = performances.count(:match_performance)

      # player.save
    end
  end

  def player_total_goals(players)
    players.each do |player|
      goals = Goal.where(scorer_id: player.id)
      player.total_goals = goals.count(:scorer_id)

      # player.save
    end
  end

  def player_total_assists(players)
    players.each do |player|
      assists = Goal.where(assist_id: player.id)
      player.total_assists = assists.count(:assist_id)

      # player.save
    end
  end

  def player_average_perfomance(players)
    players.each do |player|
      performances = Performance.where(player_id: player.id)
      player.average_performance = performances.average(:match_performance).to_i

      player.save
    end
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club)
  end
end

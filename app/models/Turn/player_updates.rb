class Turn::PlayerUpdates
  attr_reader :week

  Rails.cache.clear

  def initialize(week)
    @week = week
  end

  def call
    fitness_increase
    contract_decrease
    player_value
    player_wages
    player_total_skill
    player_games_played
    player_total_goals
    player_total_assists
    player_average_perfomance
  end

  def fitness_increase
    player_data.each do |player|
      if player.fitness != 100
        player.fitness += rand(0..5)
        player.fitness = 100 if player.fitness > 100
        player.save
      end
    end
  end

  def contract_decrease
    player_data.each do |player|
      if player.contract.positive?
        player.contract -= 1
        player.contract = 0 if player.contract.negative?
        player.save
      else
        player.contract = 0
        player.save
      end
    end
  end

  def player_value
    player_data.each do |player|
      if player.total_skill < 77
        player.value = player.total_skill * 259740
      elsif player.total_skill < 99
        player.value = player.total_skill * 505050
      elsif player.total_skill < 110
        player.value = player.total_skill * 772727
      else
        player.value = player.total_skill * 867546
      end

      player.save
    end
  end

  def player_wages
    player_data.each do |player|
      if player.total_skill < 77
        player.wages = player.total_skill * 845
      elsif player.total_skill < 99
        player.wages = player.total_skill * 2025
      elsif player.total_skill < 110
        player.wages = player.total_skill * 3287
      else
        player.wages = player.total_skill * 4181
      end

      player.save
    end
  end

  def player_total_skill
    player_data.each do |player|
      player.total_skill = player.total_skill

      player.save
    end
  end

  def player_games_played
    player_data.each do |player|
      performances = Performance.where(player_id: player.id)
      player.games_played = performances.count(:match_performance)

      player.save
    end
  end

  def player_total_goals
    player_data.each do |player|
      goals = Goal.where(scorer_id: player.id)
      player.total_goals = goals.count(:scorer_id)

      player.save
    end
  end

  def player_total_assists
    player_data.each do |player|
      assists = Goal.where(assist_id: player.id)
      player.total_assists = assists.count(:assist_id)

      player.save
    end
  end

  def player_average_perfomance
    player_data.each do |player|
      performances = Performance.where(player_id: player.id)
      player.average_performance = performances.average(:match_performance).to_i

      player.save
    end
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end

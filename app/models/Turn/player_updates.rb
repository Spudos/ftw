class Turn::PlayerUpdates
  def call
    fitness_increase
    contract_decrease
    player_value
    player_wages
  end

  private
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

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end

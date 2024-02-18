class Turn::PlayerUpdates
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    player_upgrade
    fitness_upgrade
    fitness_increase
    contract_decrease
    player_value
    player_wages
  end

  def player_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'train%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      train_player(value[:action_id], value[:week], value[:club], value[:var2], value[:var3])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def train_player(action_id, week, club, player, skill)
    if Message.find_by(action_id:).nil?
      club_staff = Club.find_by(id: club)
      player_data = Player.find_by(name: player)
      coach = club_staff.send("staff_#{player_data.position}")

      if player_data[skill] < player_data.send("potential_#{skill}")
        if player_data[skill] < coach
          player_data[skill] += 1
          player_data.update(skill => player_data[skill])
          Message.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} suceeded! His new value is #{player_data[skill]}")
        else
          Message.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player}")  
        end
      else
        Message.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} failed due to reaching potential")
      end
    end
  end

  def fitness_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'fitness%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player_fitness(value[:action_id], value[:week], value[:club], value[:var2])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def player_fitness(action_id, week, club, player)
    if Message.find_by(action_id:).nil?
      player_data = Player.find_by(name: player)
      coach = Club.find_by(id: club)&.staff_fitness

      increased_fitness = player_data.fitness + coach
      final_fitness = increased_fitness > 100 ? 100 : increased_fitness

      player_data.update(fitness: final_fitness)

      Message.create(action_id:, week:, club:, var1: "Fitness training for #{player} was completed! His new value is #{final_fitness}")
    end
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

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end

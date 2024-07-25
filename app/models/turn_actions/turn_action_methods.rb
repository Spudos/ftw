class TurnActions::TurnActionMethods
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    player_upgrade
    fitness_upgrade
    stadium_upgrade
    property_upgrade
    coach_upgrade
    contract_renewal
    loyalty_increase
  end

  private

  def player_upgrade
    hash = {}

    TurnActions.where('var1 LIKE ?', 'train%').where(week:).each do |turn|
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
      train_player(value[:action_id], value[:week], value[:club_id].to_i, value[:var2], value[:var3])
      turn = TurnActions.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def train_player(action_id, week, club_id, player, skill)
    if Message.find_by(action_id:).nil?
      club_staff = Club.find_by(id: club_id)
      player_data = Player.find_by(name: player)
      coach = club_staff.send("staff_#{player_data.position}")

      if player_data[skill] < player_data.send("potential_#{skill}")
        if player_data[skill] < coach
          player_data[skill] += 1
          player_data.update(skill => player_data[skill])
          Message.create(action_id:, week:, club_id:,
                         var1: "Training #{player} in #{skill} suceeded! His new value is #{player_data[skill]}")
        else
          Message.create(action_id:, week:, club_id:,
                         var1: "Training #{player} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player}")  
        end
      else
        player_data["potential_#{skill}_coached"] = true
        player_data.save
        Message.create(action_id:, week:, club_id:, var1: "Training #{player} in #{skill} failed due to reaching potential")
      end
    end
  end

  def fitness_upgrade
    hash = {}

    TurnActions.where('var1 LIKE ?', 'fitness%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player_fitness(value[:action_id], value[:week], value[:club_id].to_i, value[:var2])
      turn = TurnActions.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def player_fitness(action_id, week, club_id, player)
    if Message.find_by(action_id:).nil?
      player_data = Player.find_by(name: player)
      coach = Club.find_by(id: club_id)&.staff_fitness

      increased_fitness = player_data.fitness + coach
      final_fitness = increased_fitness > 100 ? 100 : increased_fitness

      player_data.update(fitness: final_fitness)

      Message.create(action_id:, week:, club_id:,
                     var1: "Fitness training for #{player} was completed! His new value is #{final_fitness}")
    end
  end

  def stadium_upgrade
    hash = {}

    TurnActions.where('var1 LIKE ?', 'stand%').where(week:).each do |turn|
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
      if Message.find_by(action_id: value[:action_id]).nil?
        if value[:var2] == nil
          cost = value[:var3]
        else
          cost = value[:var2].to_i * 1000
        end

        Turn::BankAdjustment.new(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2], cost).call
        add_to_stadium_upgrades(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2])
        turn = TurnActions.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_stadium_upgrades(action_id, week, club_id, stand, seats)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club_id:, var1: stand, var2: seats.to_i, var3: 0)
    end
  end

  def property_upgrade
    turns = TurnActions.where('var1 LIKE ?', 'property').where(week:)
    hash = {}

    turns.each do |turn|
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
      if Message.find_by(action_id: value[:action_id]).nil?
        Turn::BankAdjustment.new(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2], value[:var3]).call
        add_to_property_upgrades(value[:action_id], value[:week], value[:club_id].to_i, value[:var2])
        turn = TurnActions.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_property_upgrades(action_id, week, club_id, prop)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club_id:, var1: prop, var3: 0)
    end
  end

  def coach_upgrade
    hash = {}

    TurnActions.where('var1 LIKE ?', 'coach%').where(week:).each do |turn|
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
      if Message.find_by(action_id: value[:action_id]).nil?
        Turn::BankAdjustment.new(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2], value[:var3]).call
        add_to_coach_upgrades(value[:action_id], value[:week], value[:club_id].to_i, value[:var2])
        turn = TurnActions.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_coach_upgrades(action_id, week, club_id, coach)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club_id:, var1: coach, var3: 0)
    end
  end

  def contract_renewal
    hash = {}

    TurnActions.where('var1 LIKE ?', 'contract%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # contract
        var2: turn.var2, # player_id
        var3: turn.var3, # amount
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)

        if rand(0..100) > (80 - (player.loyalty + (value[:var3].to_i / 100_000)))
          player.contract = 24
          player.save

          Turn::BankAdjustment.new(value[:action_id],
                                   value[:week],
                                   value[:club_id].to_i,
                                   value[:var1],
                                   player.name,
                                   value[:var3]).call
        else
          if player.loyalty > 5
            player.loyalty -= 5
            player.save
          end

          Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id].to_i,
                         var1: "Your contract renewal for #{player.name} failed due to the player choosing not to renew")
        end

        turn = TurnActions.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def loyalty_increase
    hash = {}

    TurnActions.where('var1 LIKE ?', 'loyalty%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # loyalty
        var2: turn.var2, # player_id
        var3: turn.var3, # amount
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)

        player.loyalty += (value[:var3].to_i / 100_000).to_i
        player.save

        Turn::BankAdjustment.new(value[:action_id],
                                 value[:week],
                                 value[:club_id].to_i,
                                 value[:var1],
                                 player.name,
                                 value[:var3]).call

        turn = TurnActions.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end
end

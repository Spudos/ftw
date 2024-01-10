module TurnsPlayerHelper
  def player_upgraderades(week)
    turns = Turn.where("var1 LIKE ?", 'train%').where(week: week)
    hash = {}

    turns.each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        Actioned: turn.date_completed
      }
  end

    hash.each do |key, value|
      train_player(value[:action_id], value[:week], value[:club], value[:var2], value[:var3])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def train_player(action_id, week, club, player, skill)
    existing_training = Messages.find_by(action_id: action_id)

    if existing_training.nil?
      club_staff = Club.find_by(abbreviation: club)
      player_data = Player.find_by(club: club, name: player)
      coach = club_staff.send("staff_#{player_data.pos}")

      if player_data[skill] < player_data.send("potential_#{skill}")
        if player_data[skill] < coach
          player_data[skill] += 1
          player_data.update(skill => player_data[skill])
          Messages.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} suceeded! His new value is #{player_data[skill]}")
        else
          Messages.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player}")  
        end
      else
        Messages.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} failed due to reaching potential")
      end
    end
  end
end

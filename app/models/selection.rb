class Selection < ApplicationRecord
  def auto_selection(params, turn)
    if params.present? && !turn.auto_selections
      Club.all.each do |club|
        if club.managed == true
          managed_squad_check(club)
        else
          run_auto_selection(club)
        end
        turn.update(auto_selections: true)
      end
    elsif params.nil?
      Error.create(error_type: 'auto_selection', message: 'Please select a week before trying to process Auto Selections.')
    else
      Error.create(error_type: 'auto_selection', message: 'Auto Selections for that week have already been processed.')
    end
  end

  def managed_squad_check(club)
    current_selection = Selection.where(club_id: club.id)
    run_auto_selection(club) if current_selection.count < 11

    selection_issue = false

    player_info = get_player_info(current_selection)

    player_info.each do |_player, club_id, available|
      selection_issue = true if !available.zero?
      selection_issue = true if club.id != club_id

      break if selection_issue
    end

    run_auto_selection(club) if selection_issue
  end

  def get_player_info(current_selection)
    player_info = []
    current_selection.each do |selected_player|
      player = Player.find_by(id: selected_player.player_id)
      player_info << [player.id, player.club_id, player.available] if player
    end

    player_info
  end

  def run_auto_selection(club)
    Selection.where(club_id: club).destroy_all

    dfc_number, mid_number, att_number = formation_picker

    pick_gkp(club)
    pick_dfc(club, dfc_number)
    pick_mid(club, mid_number)
    pick_att(club, att_number)
  end

  def formation_picker
    selected_formation = formations.sample

    dfc_number = selected_formation[0]
    mid_number = selected_formation[1]
    att_number = selected_formation[2]

    return dfc_number, mid_number, att_number
  end

  def pick_gkp(club)
    gkp = Player.where(club_id: club.id, position: 'gkp', available: 0).order(total_skill: :desc).first
    Selection.create(club_id: club.id, player_id: gkp.id)
  end

  def pick_dfc(club, dfc_number)
    dfc = Player.where(club_id: club.id, position: 'dfc', available: 0).order(total_skill: :desc).limit(dfc_number)
    dfc.each do |player|
      Selection.create(club_id: club.id, player_id: player.id)
    end
  end

  def pick_mid(club, mid_number)
    mid = Player.where(club_id: club.id, position: 'mid', available: 0).order(total_skill: :desc).limit(mid_number)
    mid.each do |player|
      Selection.create(club_id: club.id, player_id: player.id)
    end
  end

  def pick_att(club, att_number)
    att = Player.where(club_id: club.id, position: 'att', available: 0).order(total_skill: :desc).limit(att_number)
    att.each do |player|
      Selection.create(club_id: club.id, player_id: player.id)
    end
  end

  def formations
    [[4, 4, 2],
     [4, 3, 3],
     [3, 4, 3],
     [5, 3, 2],
     [5, 4, 1],
     [5, 2, 3]]
  end
end

#------------------------------------------------------------------------------
# Selection
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         INTEGER              false   true              
# club       varchar              true    false             
# player_id  INTEGER              true    false             
# created_at datetime(6)          false   false             
# updated_at datetime(6)          false   false             
#
#------------------------------------------------------------------------------

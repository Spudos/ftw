#------------------------------------------------------------------------------
# Club
#
# Name              SQL Type             Null    Primary Default
# ----------------- -------------------- ------- ------- ----------
# id                INTEGER              false   true              
# name              varchar              true    false             
# club_id      varchar              true    false             
# created_at        datetime(6)          false   false             
# updated_at        datetime(6)          false   false             
# ground_name       varchar              true    false             
# stand_n_name      varchar              true    false             
# stand_n_condition INTEGER              true    false             
# stand_n_capacity  INTEGER              true    false             
# stand_s_name      varchar              true    false             
# stand_s_condition INTEGER              true    false             
# stand_s_capacity  INTEGER              true    false             
# stand_e_name      varchar              true    false             
# stand_e_condition INTEGER              true    false             
# stand_e_capacity  INTEGER              true    false             
# stand_w_name      varchar              true    false             
# stand_w_condition INTEGER              true    false             
# stand_w_capacity  INTEGER              true    false             
# pitch             INTEGER              true    false             
# hospitality       INTEGER              true    false             
# facilities        INTEGER              true    false             
# staff_fitness     INTEGER              true    false             
# staff_gkp         INTEGER              true    false             
# staff_dfc         INTEGER              true    false             
# staff_mid         INTEGER              true    false             
# staff_att         INTEGER              true    false             
# staff_scouts      INTEGER              true    false             
# color_primary     varchar              true    false             
# color_secondary   varchar              true    false             
# bank_bal          INTEGER              true    false             
# managed           boolean              true    false             
# manager           varchar              true    false             
# manager_email     varchar              true    false             
# league            varchar              true    false             
#
#------------------------------------------------------------------------------

class Club < ApplicationRecord
  has_many :players

  def finance_items(club)
    highest_week_number = Message.maximum(:week)
    messages = Message.where(club_id: club, week: highest_week_number)

    items = {
      transfers_out: messages.where(var2: 'transfers_out').sum(:var3),
      club_shop_online: messages.where(var2: 'club_shop_online').sum(:var3),
      club_shop_match: messages.where(var2: 'club_shop_match').sum(:var3),
      gate_receipts: messages.where(var2: 'gate_receipts').sum(:var3),
      hospitality: messages.where(var2: 'hospitality').sum(:var3),
      facilities: messages.where(var2: 'facilities').sum(:var3),
      programs: messages.where(var2: 'programs').sum(:var3),
      player_wages: messages.where(var2: 'player_wages').sum(:var3),
      staff_wages: messages.where(var2: 'staff_wages').sum(:var3),
      transfers_in: messages.where(var2: 'transfers_in').sum(:var3),
      stadium_upkeep: messages.where(var2: 'stadium_upkeep').sum(:var3),
      policing: messages.where(var2: 'policing').sum(:var3),
      stewards: messages.where(var2: 'stewards').sum(:var3),
      medical: messages.where(var2: 'medical').sum(:var3),
      bonuses: messages.where(var2: 'bonuses').sum(:var3),
      contracts: messages.where(var2: 'contracts').sum(:var3),
      upgrades: messages.where(var2: 'upgrades').sum(:var3)
    }

    return items
  end
end

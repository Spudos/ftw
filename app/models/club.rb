#------------------------------------------------------------------------------
# Club
#
# Name              SQL Type             Null    Primary Default
# ----------------- -------------------- ------- ------- ----------
# id                INTEGER              false   true              
# name              varchar              true    false             
# abbreviation      varchar              true    false             
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
end

class Commentary < ApplicationRecord
end
#------------------------------------------------------------------------------
# Commentary
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         INTEGER              false   true              
# match_id   varchar              true    false             
# minute     INTEGER              true    false             
# commentary TEXT                 true    false             
# created_at datetime(6)          false   false             
# updated_at datetime(6)          false   false             
# event      varchar              true    false             
# home_score INTEGER              true    false             
# away_score INTEGER              true    false             
#
#------------------------------------------------------------------------------

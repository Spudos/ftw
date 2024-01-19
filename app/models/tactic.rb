class Tactic < ApplicationRecord
end
#------------------------------------------------------------------------------
# Tactic
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             INTEGER              false   true              
# abbreviation   varchar              true    false             
# tactics        INTEGER              true    false             
# created_at     datetime(6)          false   false             
# updated_at     datetime(6)          false   false             
# dfc_aggression INTEGER              true    false             
# mid_aggression INTEGER              true    false             
# att_aggression INTEGER              true    false             
#
#------------------------------------------------------------------------------

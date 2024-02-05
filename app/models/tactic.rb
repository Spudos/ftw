class Tactic < ApplicationRecord
  validates :abbreviation, presence: true
  validates :dfc_aggression, presence: true, numericality: { equal_to: 0 }
  validates :mid_aggression, presence: true, numericality: { equal_to: 0 }
  validates :att_aggression, presence: true, numericality: { equal_to: 0 }
  validates :press, presence: true, numericality: { equal_to: 0 }
  validates :tactics, presence: true, numericality: { equal_to: 0 }
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

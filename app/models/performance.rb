class Performance < ApplicationRecord
  belongs_to :player
end
#------------------------------------------------------------------------------
# Performance
#
# Name                   SQL Type             Null    Primary Default
# ---------------------- -------------------- ------- ------- ----------
# id                     INTEGER              false   true              
# match_id               INTEGER              true    false             
# player_id              INTEGER              true    false             
# club                   varchar              true    false             
# name                   varchar              true    false             
# player_position        varchar              true    false             
# player_position_detail varchar              true    false             
# match_performance      INTEGER              true    false             
# created_at             datetime(6)          false   false             
# updated_at             datetime(6)          false   false             
# competition            varchar              true    false             
#
#------------------------------------------------------------------------------

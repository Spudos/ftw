class Goal < ApplicationRecord
  belongs_to :scorer, class_name: 'Player'
  belongs_to :assist, class_name: 'Player', optional: true
end
#------------------------------------------------------------------------------
# Goal
#
# Name        SQL Type             Null    Primary Default
# ----------- -------------------- ------- ------- ----------
# id          INTEGER              false   true              
# match_id    INTEGER              true    false             
# week_number INTEGER              true    false             
# minute      INTEGER              true    false             
# assist_id   INTEGER              true    false             
# scorer_id   INTEGER              true    false             
# created_at  datetime(6)          false   false             
# updated_at  datetime(6)          false   false             
# competition varchar              true    false             
#
#------------------------------------------------------------------------------

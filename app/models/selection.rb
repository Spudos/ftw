class Selection < ApplicationRecord
  belongs_to :turnsheet
  attribute :turnsheet_id, :integer
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

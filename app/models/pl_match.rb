# == Schema Information
#
# Table name: pl_matches
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  player_id  :integer
#  match_perf :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PlMatch < ApplicationRecord
  belongs_to :player
end

#------------------------------------------------------------------------------
# PlMatch
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         INTEGER              false   true              
# match_id   INTEGER              true    false             
# player_id  INTEGER              true    false             
# match_perf INTEGER              true    false             
# created_at datetime(6)          false   false             
# updated_at datetime(6)          false   false             
#
#------------------------------------------------------------------------------

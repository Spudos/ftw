# == Schema Information
#
# Table name: pl_stats
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  motm       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :integer
#  goal       :boolean
#  assist     :boolean
#
class PlStat < ApplicationRecord
  belongs_to :player
end

#------------------------------------------------------------------------------
# PlStat
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         INTEGER              false   true              
# player_id  INTEGER              true    false             
# motm       INTEGER              true    false             
# created_at datetime(6)          false   false             
# updated_at datetime(6)          false   false             
# match_id   INTEGER              true    false             
# goal       boolean              true    false             
# assist     boolean              true    false             
# time       INTEGER              true    false             
#
#------------------------------------------------------------------------------

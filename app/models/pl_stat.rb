# == Schema Information
#
# Table name: pl_statistics
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  man_of_the_match       :integer
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
# man_of_the_match       INTEGER              true    false             
# created_at datetime(6)          false   false             
# updated_at datetime(6)          false   false             
# match_id   INTEGER              true    false             
# goal       boolean              true    false             
# assist     boolean              true    false             
# time       INTEGER              true    false             
#
#------------------------------------------------------------------------------

# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  match_id      :integer
#  hm_team       :string
#  aw_team       :string
#  hm_poss       :integer
#  aw_poss       :integer
#  hm_cha        :integer
#  aw_cha        :integer
#  hm_cha_on_tar :integer
#  aw_cha_on_tar :integer
#  hm_motm       :string
#  aw_motm       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  hm_goal       :integer
#  aw_goal       :integer
#
class Matches < ApplicationRecord
end

#------------------------------------------------------------------------------
# Matches
#
# Name          SQL Type             Null    Primary Default
# ------------- -------------------- ------- ------- ----------
# id            INTEGER              false   true              
# match_id      INTEGER              true    false             
# hm_team       varchar              true    false             
# aw_team       varchar              true    false             
# hm_poss       INTEGER              true    false             
# aw_poss       INTEGER              true    false             
# hm_cha        INTEGER              true    false             
# aw_cha        INTEGER              true    false             
# hm_cha_on_tar INTEGER              true    false             
# aw_cha_on_tar INTEGER              true    false             
# hm_motm       varchar              true    false             
# aw_motm       varchar              true    false             
# created_at    datetime(6)          false   false             
# updated_at    datetime(6)          false   false             
# hm_goal       INTEGER              true    false             
# aw_goal       INTEGER              true    false             
# week_number   INTEGER              true    false             
#
#------------------------------------------------------------------------------

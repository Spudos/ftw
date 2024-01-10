# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  match_id      :integer
#  home_team       :string
#  away_team       :string
#  home_possession       :integer
#  away_possession       :integer
#  home_cha        :integer
#  away_cha        :integer
#  home_chance_on_target :integer
#  away_chance_on_target :integer
#  home_man_of_the_match       :string
#  away_man_of_the_match       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  home_goals       :integer
#  away_goals       :integer
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
# home_team       varchar              true    false             
# away_team       varchar              true    false             
# home_possession       INTEGER              true    false             
# away_possession       INTEGER              true    false             
# home_cha        INTEGER              true    false             
# away_cha        INTEGER              true    false             
# home_chance_on_target INTEGER              true    false             
# away_chance_on_target INTEGER              true    false             
# home_man_of_the_match       varchar              true    false             
# away_man_of_the_match       varchar              true    false             
# created_at    datetime(6)          false   false             
# updated_at    datetime(6)          false   false             
# home_goals       INTEGER              true    false             
# away_goals       INTEGER              true    false             
# week_number   INTEGER              true    false             
#
#------------------------------------------------------------------------------

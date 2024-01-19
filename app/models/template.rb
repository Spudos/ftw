class Template < ApplicationRecord
  enum commentary_type: {
    match_general: 'match_general',
    match_chance: 'match_chance',
    match_chance_tar: 'match_chance_tar',
    match_goal: 'match_goal'
  }

  def self.random_match_general_commentary
    commentaries = where(commentary_type: :match_general).pluck(:text)
    commentaries.sample
  end

  def self.random_match_chance_commentary
    commentaries = where(commentary_type: :match_chance).pluck(:text)
    commentaries.sample
  end

  def self.random_match_chance_tar_commentary
    commentaries = where(commentary_type: :match_chance_tar).pluck(:text)
    commentaries.sample
  end

  def self.random_match_goal_commentary
    commentaries = where(commentary_type: :match_goal).pluck(:text)
    commentaries.sample
  end
end

#------------------------------------------------------------------------------
# Template
#
# Name            SQL Type             Null    Primary Default
# --------------- -------------------- ------- ------- ----------
# id              INTEGER              false   true              
# commentary_type varchar              true    false             
# text            varchar              true    false             
# created_at      datetime(6)          false   false             
# updated_at      datetime(6)          false   false             
#
#------------------------------------------------------------------------------

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

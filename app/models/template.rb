# Assuming you have a Template model representing the "template" table
class Template < ApplicationRecord
  # Assuming you have a "commentary_type" column and a "text" column in the "template" table
  enum commentary_type: {
    match_general: 'match_general',
    match_chance: 'match_chance'
    # Add other commentary types here if needed
  }

  def self.random_match_general_commentary
    commentaries = where(commentary_type: :match_general).pluck(:text)
    commentaries.sample
  end

  def self.random_match_chance_commentary
    commentaries = where(commentary_type: :match_chance).pluck(:text)
    commentaries.sample
  end
end

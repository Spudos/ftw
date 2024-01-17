class Goal < ApplicationRecord
  belongs_to :scorer, class_name: 'Player'
  belongs_to :assist, class_name: 'Player', optional: true
end
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

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

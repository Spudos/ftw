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

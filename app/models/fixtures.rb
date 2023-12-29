# == Schema Information
#
# Table name: fixtures
#
#  id          :integer          not null, primary key
#  match_id    :integer
#  week_number :integer
#  home        :string
#  away        :string
#  comp        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Fixtures < ApplicationRecord
end

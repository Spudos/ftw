# == Schema Information
#
# Table name: fixtures
#
#  id          :integer          not null, primary key
#  id    :integer
#  week_number :integer
#  home        :string
#  away        :string
#  comp        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Fixtures < ApplicationRecord
end

#------------------------------------------------------------------------------
# Fixtures
#
# Name        SQL Type             Null    Primary Default
# ----------- -------------------- ------- ------- ----------
# id          INTEGER              false   true              
# id    INTEGER              true    false             
# week_number INTEGER              true    false             
# home        varchar              true    false             
# away        varchar              true    false             
# comp        varchar              true    false             
# created_at  datetime(6)          false   false             
# updated_at  datetime(6)          false   false             
#
#------------------------------------------------------------------------------

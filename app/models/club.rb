# == Schema Information
#
# Table name: clubs
#
#  id           :integer          not null, primary key
#  name         :string
#  abbreviation :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Club < ApplicationRecord
  
end

#------------------------------------------------------------------------------
# Club
#
# Name         SQL Type             Null    Primary Default
# ------------ -------------------- ------- ------- ----------
# id           INTEGER              false   true              
# name         varchar              true    false             
# abbreviation varchar              true    false             
# created_at   datetime(6)          false   false             
# updated_at   datetime(6)          false   false             
#
#------------------------------------------------------------------------------

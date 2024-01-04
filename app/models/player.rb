# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  name        :string
#  age         :integer
#  nationality :string
#  pos         :string
#  pa          :integer
#  co          :integer
#  ta          :integer
#  ru          :integer
#  sh          :integer
#  dr          :integer
#  df          :integer
#  of          :integer
#  fl          :integer
#  st          :integer
#  cr          :integer
#  fit         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  club        :string
#  cons        :integer
#
class Player < ApplicationRecord
  has_one :pl_stat
  has_many :pl_match

  def total_skill
    if pos == 'gkp'
      base_skill + gkp_skill
    elsif pos == 'dfc'
      base_skill + dfc_skill
    elsif pos == 'mid'
      base_skill + mid_skill
    else
      base_skill + att_skill
    end
  end

  def id_name_with_position_and_skill
    "#{id} #{name} - #{pos} (Skill: #{total_skill})"
  end

  def base_skill
    pa + co + ta + ru + sh + dr + df + of + fl + st + cr
  end

  def gkp_skill
    pa + co + ta + sh + of + st
  end 

  def dfc_skill
    co + ta + ru + df + st + cr
  end

  def mid_skill
    pa + co + sh + dr + fl + cr
  end

  def att_skill
    co + ru + sh + dr + of + fl
  end

  def match_perf(player)
    mod = 0

    if player.pos == 'gkp'
      (player.gkp_skill * player.fit / 100) + player.calc_pl_perf_ran(player) + mod
    elsif player.pos == 'dfc'
      (player.dfc_skill * player.fit / 100) + player.calc_pl_perf_ran(player) + mod
    elsif player.pos == 'mid'
      (player.mid_skill * player.fit / 100) + player.calc_pl_perf_ran(player) + mod
    else
      (player.att_skill * player.fit / 100) + player.calc_pl_perf_ran(player) + mod
    end
  end

  def calc_pl_perf_ran(player)
    cons = player.cons
    random_number = rand(-cons..cons)
  end
end

def self.update_pot_for_gkp
  players = Player.where(pos: 'gkp')
  players.each do |player|
    updates = {
      pot_pa: player.pa + rand(1..10),
      pot_co: player.co + rand(1..10),
      pot_ta: player.ta + rand(1..10),
      pot_ru: player.ru + rand(1..5),
      pot_sh: player.sh + rand(1..10),
      pot_dr: player.dr + rand(1..5),
      pot_df: player.df + rand(1..5),
      pot_of: player.of + rand(1..10),
      pot_fl: player.fl + rand(1..5),
      pot_st: player.st + rand(1..10),
      pot_cr: player.cr + rand(1..5)
    }
    player.update(updates)
  end
end

def self.update_pot_for_dfc
  players = Player.where(pos: 'dfc')
  players.each do |player|
    updates = {
      pot_pa: player.pa + rand(1..5),
      pot_co: player.co + rand(1..10),
      pot_ta: player.ta + rand(1..10),
      pot_ru: player.ru + rand(1..10),
      pot_sh: player.sh + rand(1..3),
      pot_dr: player.dr + rand(1..2),
      pot_df: player.df + rand(1..10),
      pot_of: player.of + rand(1..5),
      pot_fl: player.fl + rand(1..2),
      pot_st: player.st + rand(1..10),
      pot_cr: player.cr + rand(1..10)
    }
    player.update(updates)
  end
end

def self.update_pot_for_mid
  players = Player.where(pos: 'mid')
  players.each do |player|
    updates = {
      pot_pa: player.pa + rand(1..10),
      pot_co: player.co + rand(1..10),
      pot_ta: player.ta + rand(1..3),
      pot_ru: player.ru + rand(1..5),
      pot_sh: player.sh + rand(1..10),
      pot_dr: player.dr + rand(1..10),
      pot_df: player.df + rand(1..3),
      pot_of: player.of + rand(1..3),
      pot_fl: player.fl + rand(1..10),
      pot_st: player.st + rand(1..5),
      pot_cr: player.cr + rand(1..10)
    }
    player.update(updates)
  end
end

def self.update_pot_for_att
  players = Player.where(pos: 'att')
  players.each do |player|
    updates = {
      pot_pa: player.pa + rand(1..5),
      pot_co: player.co + rand(1..10),
      pot_ta: player.ta + rand(1..3),
      pot_ru: player.ru + rand(1..10),
      pot_sh: player.sh + rand(1..10),
      pot_dr: player.dr + rand(1..10),
      pot_df: player.df + rand(1..3),
      pot_of: player.of + rand(1..10),
      pot_fl: player.fl + rand(1..10),
      pot_st: player.st + rand(1..5),
      pot_cr: player.cr + rand(1..5)
    }
    player.update(updates)
  end
end

#------------------------------------------------------------------------------
# Player
#
# Name        SQL Type             Null    Primary Default
# ----------- -------------------- ------- ------- ----------
# id          INTEGER              false   true              
# name        varchar              true    false             
# age         INTEGER              true    false             
# nationality varchar              true    false             
# pos         varchar              true    false             
# pa          INTEGER              true    false             
# co          INTEGER              true    false             
# ta          INTEGER              true    false             
# ru          INTEGER              true    false             
# sh          INTEGER              true    false             
# dr          INTEGER              true    false             
# df          INTEGER              true    false             
# of          INTEGER              true    false             
# fl          INTEGER              true    false             
# st          INTEGER              true    false             
# cr          INTEGER              true    false             
# fit         INTEGER              true    false             
# created_at  datetime(6)          false   false             
# updated_at  datetime(6)          false   false             
# club        varchar              true    false             
# cons        INTEGER              true    false             
#
#------------------------------------------------------------------------------

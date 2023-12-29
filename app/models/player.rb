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

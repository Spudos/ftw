class Player < ApplicationRecord
  def base_skill
    pa + co + ta + ru + sh + dr + df + of + fl + st + cr
  end

  def gkp_skill
    pa + co + ta + sh + of + st
  end

  def def_skill
    co + ta + ru + df + st + cr
  end

  def mid_skill
    pa + co + sh + dr + fl + cr
  end

  def att_skill
    co + ru + sh + dr + of + fl
  end

  def total_skill
    if pos == 'gkp'
      base_skill + gkp_skill
    elsif pos == 'def'
      base_skill + def_skill
    elsif pos == 'mid'
      base_skill + mid_skill
    else
      base_skill + att_skill
    end
  end
end


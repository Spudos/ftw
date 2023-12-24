class Player < ApplicationRecord
  def calculate_base_skill
    pa + co + ta + ru + sh + dr + df + of + fl + st + cr
  end

  def calculate_gkp_skill
    pa + co + ta + sh + of + st
  end

  def calculate_def_skill
    co + ta + ru + df + st + cr
  end

  def calculate_mid_skill
    pa + co + sh + dr + fl + cr
  end

  def calculate_att_skill
    co + ru + sh + dr + of + fl
  end

  def calculate_total_skill
    if pos == 'gkp'
      calculate_base_skill + calculate_gkp_skill
    elsif pos == 'def'
      calculate_base_skill + calculate_def_skill
    elsif pos == 'mid'
      calculate_base_skill + calculate_mid_skill
    else
      calculate_base_skill + calculate_att_skill
    end
  end
  

end


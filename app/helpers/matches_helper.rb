module MatchesHelper
  def tactic(number)
    case number
    when 0
      "Normal"
    when 1
      "Passing"
    when 2
      "Defensive"
    when 3
      "Attacking"
    when 4
      "Wide"
    when 5
      "Narrow"
    else
      "Direct"
    end
  end

  def press(number)
    case number
    when 0
      "Heavy Metal"
    when 1
      "Strong"
    when 2
      "Normal"
    when 3
      "None"
    when 4
      "Wide"
    when 5
      "Late"
    else
      "Late Heavy Metal"
    end
  end
end
class Match::MinuteByMinute::MinuteByMinutePress
  attr_reader :selection_complete, :tactic, :i

  def initialize(selection_complete, tactic, i)
    @selection_complete = selection_complete
    @tactic = tactic
    @i = i
  end

  def call
    minute_by_minute_press = []

    selection_complete.each do |player|
      tactic_record = tactic.find { |hash| hash[:club_id] == player[:club_id] }
      press = tactic_record[:press]

      player[:performance] = player[:performance] + (press * press_multiplier(press, i))

      minute_by_minute_press << player
    end

    return minute_by_minute_press
  end

  private

  def press_multiplier(press, i)
    if i < 15
      multiplier = 3
    elsif i < 30
      multiplier = 2
    elsif i < 45
      multiplier = 1
    elsif i < 60
      multiplier = -1
    elsif i < 75
      multiplier = -2
    else
      multiplier = -3
    end

    return multiplier
  end
end

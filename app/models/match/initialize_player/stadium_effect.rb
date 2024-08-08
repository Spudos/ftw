class Match::StadiumEffect
  attr_reader :attendance_size, :totals_blend

  def initialize(totals_blend, attendance_size)
    @attendance_size = attendance_size
    @totals_blend = totals_blend
  end

  def call
    if @totals_blend.nil? || @attendance_size.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    if attendance_size <= 10000
      stadium_effect = 0
    elsif attendance_size <= 20000
      stadium_effect = 2
    elsif attendance_size <= 30000
      stadium_effect = 5
    elsif attendance_size <= 40000
      stadium_effect = 8
    elsif attendance_size <= 50000
      stadium_effect = 10
    elsif attendance_size <= 60000
      stadium_effect = 12
    elsif attendance_size <= 70000
      stadium_effect = 15
    else
      stadium_effect = 20
    end

    totals_blend.first[:defense] += stadium_effect
    totals_blend.first[:midfield] += stadium_effect
    totals_blend.first[:attack] += stadium_effect

    totals_blend
  end
end

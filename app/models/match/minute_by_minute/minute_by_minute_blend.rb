class Match::MinuteByMinute::MinuteByMinuteBlend
  attr_reader :selection_complete

  def initialize(selection_complete)
    @selection_complete = selection_complete
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selection_complete.nil?

    team_blend_factor = team_blend_calculation

    minute_by_minute_blend = apply_blend_factor(team_blend_factor)

    return minute_by_minute_blend
  end

  private

  def team_blend_calculation
    selections_by_team = selection_complete.group_by { |selection| selection[:club_id] }

    team_blend = get_blend_values(selections_by_team)

    team_blend_varience = get_blend_varience(team_blend)

    get_blend_factor(team_blend_varience)
  end

  def get_blend_values(selections_by_team)
    team_blend = []

    selections_by_team.map do |club_id, selections|
      dfc_blend = []
      mid_blend = []
      att_blend = []
      process_selections(selections, dfc_blend, mid_blend, att_blend)
      team_blend << { club_id:, dfc_blend:, mid_blend:, att_blend: }
    end

    team_blend
  end

  def process_selections(selections, dfc_blend, mid_blend, att_blend)
    selections.each do |selection|
      case selection[:position]
      when 'gkp', 'dfc'
        dfc_blend << selection[:blend]
      when 'mid'
        mid_blend << selection[:blend]
      when 'att'
        att_blend << selection[:blend]
      end
    end
  end

  def get_blend_varience(team_blend)
    team_blend_varience = []

    team_blend.each do |team|
      dfc = team[:dfc_blend].max - team[:dfc_blend].min
      mid = team[:mid_blend].max - team[:mid_blend].min
      att = team[:att_blend].max - team[:att_blend].min

      team_blend_varience << { club_id: team[:club_id], dfc:, mid:, att: }
    end

    team_blend_varience
  end

  def get_blend_factor(team_blend_varience)
    team_blend_factor = []

    team_blend_varience.each do |team|
      dfc = (10 - team[:dfc])
      mid = (10 - team[:mid])
      att = (10 - team[:att])

      team_blend_factor << { club_id: team[:club_id], dfc:, mid:, att: }
    end

    team_blend_factor
  end

  def apply_blend_factor(team_blend_factor)
    minute_by_minute_blend = []

    selection_complete.each do |selection|
      blend_factor = team_blend_factor.find { |team| team[:club_id] == selection[:club_id] }

      adjusted_performance = selection[:performance]

      case selection[:position]
      when 'gkp', 'dfc'
        adjusted_performance += blend_factor[:dfc]
      when 'mid'
        adjusted_performance += blend_factor[:mid]
      when 'att'
        adjusted_performance += blend_factor[:att]
      end

      hash = { club_id: selection[:club_id],
               player_id: selection[:player_id],
               name: selection[:name],
               total_skill: selection[:total_skill],
               position: selection[:position],
               position_detail: selection[:position_detail],
               blend: selection[:blend],
               star: selection[:star],
               fitness: selection[:fitness],
               performance: adjusted_performance }

      minute_by_minute_blend << hash
    end

    minute_by_minute_blend
  end
end

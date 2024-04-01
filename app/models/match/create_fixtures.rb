class Match::CreateFixtures
  attr_reader :selected_week, :competition

  def initialize(selected_week, competition)
    @selected_week = selected_week
    @competition = competition
  end

  def call
    if competition == nil
      fixtures = Fixture.where(week_number: selected_week)
    else
      fixtures = Fixture.where(week_number: selected_week, comp: competition)
    end

    fixture_list = []
    fixtures.each do |fixture|
      unless Match.exists?(match_id: fixture.id)
        fixture_list << {
          id: fixture.id,
          club_home: fixture.home,
          club_away: fixture.away,
          week_number: fixture.week_number,
          competition: fixture.comp
        }
      end
    end

    if fixture_list.empty?
      raise StandardError, "No outstanding #{params[:competition]} fixtures found for week #{params[:selected_week]}. class:#{self.class.name}"
    end
    fixture_list
  end
end

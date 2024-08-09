class Match::InitializeMatch::GetFixture
  attr_reader :selected_week, :competition

  def initialize(selected_week, competition)
    @selected_week = selected_week
    @competition = competition
  end

  def call
    fixture_list = populate_fixture_list(call_fixtures)

    if fixture_list.empty?
      raise StandardError, "No outstanding #{competition} fixtures found for week #{selected_week} class:#{self.class.name}"
    end

    fixture_list
  end

  private

  def call_fixtures
    if competition.nil?
      Fixture.where(week_number: selected_week)&.pluck(:id, :home, :away, :week_number, :comp)
    else
      Fixture.where(week_number: selected_week, comp: competition)&.pluck(:id, :home, :away, :week_number, :comp)
    end
  end

  def populate_fixture_list(fixtures)
    fixture_list = []
    fixtures.each do |fixture|
      fixture_list << { id: fixture[0],
                        club_home: fixture[1],
                        club_away: fixture[2],
                        week_number: fixture[3],
                        competition: fixture[4] }
    end

    fixture_list
  end
end

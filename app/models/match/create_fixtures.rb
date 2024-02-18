class Match::CreateFixtures
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    if params[:competition] == nil
      fixtures = Fixture.where(week_number: params[:selected_week])
    else
      fixtures = Fixture.where(week_number: params[:selected_week], comp: params[:competition])
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

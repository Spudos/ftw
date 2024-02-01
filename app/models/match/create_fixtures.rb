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
      fixture_list << {
        id: fixture.id,
        club_home: fixture.home,
        club_away: fixture.away,
        week_number: fixture.week_number,
        competition: fixture.comp
      }
    end
    fixture_list
  end
end
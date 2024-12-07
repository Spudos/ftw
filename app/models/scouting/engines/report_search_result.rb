class Scouting::Engines::ReportSearchResult
  attr_reader :week, :club_id, :player

  def initialize(week, club_id, player)
    @week = week
    @club_id = club_id
    @player = player
  end

  def call
    report_search_result(@player)
  end

  private

  def report_search_result(player)
    var1, var2, var3 = generate_report_vars(player)

    Message.create(week: @week,
                   club_id: @club_id,
                   var1:,
                   var2:,
                   var3:,
                   action_id: "scouting#{@week}#{@club_id}")
  end

  def generate_report_vars(player)
    if player.nil?
      var1 = 'Despite their best efforts, the scouts could not find a suitable player for you to consider signing.'
      var2 = nil
      var3 = nil
    else
      club_name = Club.find_by(id: player.club_id).name
      var1 = "The scouts have found a player for you to consider signing. His name is #{player.name}, " \
             "his player id is #{player.id}. He currently plays for #{club_name}."
      var2 = player.name
      var3 = player.blend
    end
    [var1, var2, var3]
  end

end
class Scouting::Scouting
  attr_reader :scout_info

  def initialize(scout_info)
    @scout_info = scout_info
    @week = scout_info[:week]
    @club_id = scout_info[:club_id]
    @skills = scout_info[:skills]
    @potential_skill = scout_info[:potential_skill]
    @blend_player = scout_info[:blend_player]
  end

  def call
    players = Scouting::Engines::SearchForPlayers.new(@scout_info).call

    if @skills || @potential_skill
      players = Scouting::Engines::SecondaryFilters.new(players, @skills, @potential_skill).call
    end

    players = Scouting::Engines::BlendMatching.new(players, @blend_player).call if @blend_player != 0

    report_search_result(players.sample)
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

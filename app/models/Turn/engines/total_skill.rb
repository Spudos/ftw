class Turn::Engines::TotalSkill
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_total_skill
  end

  private

  def player_total_skill
    # File.open('timings.txt', 'w') do |file|
    #   file.write("Started: #{Time.current}")
    # end
    players.each do |player|
      player.total_skill = player.total_skill
    end
    # File.open('timings2.txt', 'w') do |file|
    #   file.write("Ended: #{Time.current}")
    # end
  end
end

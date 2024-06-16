class Turn::Engines::Contract
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
    @contract_messages = []
  end

  def process
    players.each do |player|
      contract_decrease(player)
    end
    Message.insert_all(@contract_messages) unless @contract_messages.empty?
    players
  end

  private

  def contract_decrease(player)
    return unless player.club.managed?

    player.contract -= 1

    return unless player.contract == 3 || player.contract < 1

    if player.contract < 1
      binding.pry
      @contract_messages << { week:,
                              club_id: player.club_id,
                              var1: "#{player.name} has been released at the end of his contract with the club." }
      player.contract = 51
      player.club_id = 242
    else
      @contract_messages << { week:,
                              club_id: player.club_id,
                              var1: "#{player.name} has only 3 weeks of his contract remaining.  When it reaches zero he will be released by the club." }
    end
  end
end

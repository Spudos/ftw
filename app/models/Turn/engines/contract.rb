class Turn::Engines::Contract
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    contract_decrease
  end

  private

  def contract_decrease
    players.each do |player|
      if player.club.managed?
        player.contract -= 1

        if player.contract == 3 || player.contract < 1
          if player.contract < 1
            Message.create(week:, club_id: player.club_id,
                           var1: "#{player.name} has been released at the end of his contract with the club.")
            player.contract = 51
            player.club_id = 242
          else
            Message.create(week:, club_id: player.club_id,
                           var1: "#{player.name} has only 3 weeks of his contract remaining.  When it reaches zero he will be released by the club.")
          end
        end
      end
    end
  end
end

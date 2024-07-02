class Turn::Engines::ClubFixOverdraft
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def process
    clubs = Club.where.not(id: [241, 242]).where(managed: true)

    clubs.each do |club|
      if club.overdrawn > 3 && club.bank_bal.negative?
        action_id = "#{week}#{club.id}OD"

        counter = 0

        while club.bank_bal.negative? && counter < 3
          player = Player.where(club_id: club.id).order(total_skill: :asc).first

          proceeds = (player.value * 0.75).to_i

          player.club_id = 242
          player.save

          club.bank_bal += proceeds
          club.save

          @club_messages << { action_id:,
                              week:,
                              club_id: club.id,
                              var1: "Your bank account was credited with #{proceeds} due a player sale (#{player.name})",
                              var2: 'inc-transfers_out',
                              var3: proceeds }

          Transfer.create(week:,
                          buy_club: 242,
                          sell_club: club.id,
                          player_id: player.id,
                          bid: proceeds,
                          status: 'completed')

          counter += 1
        end

        Article.create(week:,
                       club_id: club.id,
                       image: 'club.jpg',
                       article_type: 'Club',
                       headline: "#{club.name} Financial Crisis!",
                       sub_headline: "Players Sold to Clear Debts!",
                       article: 'Directors have taken over the financial affairs of the club after they were found to be overdrawn for three weeks.  Up to three players will be sold each week until the debt is cleared.  The club is in crisis and the fans are in uproar.  The board are considering looking for a new manager to take over the club and lead them to a brighter future although no change is imminent.')

        @club_messages << { action_id:,
                            week:,
                            club_id: club.id,
                            var1: 'Your club has been overdrawn for three weeks now and the directors have stepped in to rectify the problem.  Up to three players will be sold each week until the debt is cleared',
                            var2: 'fix-od', var3: club.bank_bal }
      end

      if club.bank_bal.positive?
        club.overdrawn = 0
        club.save
      end
    end
  end
end

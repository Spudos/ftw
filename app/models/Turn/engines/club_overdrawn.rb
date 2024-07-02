class Turn::Engines::ClubOverdrawn
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def process
    clubs = Club.where.not(id: [241, 242]).where(managed: true)

    clubs.each do |club|
      if club.bank_bal.negative?
        club.overdrawn += 1
        club.save

        action_id = "#{week}#{club.id}OD"

        @club_messages << { action_id:,
                            week:,
                            club_id: club.id,
                            var1: 'Your club is overdrawn. If you do not fix the problems quickly the directors will step in and sell players to clear the debt',
                            var2: 'warn-od', var3: club.bank_bal }
      end
    end
  end
end

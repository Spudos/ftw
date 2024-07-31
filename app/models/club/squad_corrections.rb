class Club::SquadCorrections
  def initialize
    @club_messages = []
  end

  def call
    clubs = Club.where(managed: true)
    clubs.each do |club|
      players = Player.where(club_id: club.id, available: 0)

      defecit, total_defecit = player_defecit(players)

      create_player(defecit, club.id) if total_defecit.positive?
    end
  end

  def player_defecit(players)
    defecit = {
      gkp: (players.where(position: 'gkp').count - 1) * -1,
      dfc: (players.where(position: 'dfc').count - 4) * -1,
      mid: (players.where(position: 'mid').count - 4) * -1,
      att: (players.where(position: 'att').count - 3) * -1,
    }
    total_defecit = defecit.values.sum
    return defecit, total_defecit
  end

  def create_player(defecit, club_id)
    countries = ['England', 'England', 'England', 'England', 'Scotland', 'Wales',
                 'NI', 'RoI', 'Brazil', 'Argentina', 'Spain', 'France', 'Germany',
                 'Poland', 'Portugal', 'USA', 'Belgium', 'Mexico', 'Uruguay','Brazil',
                 'England', 'Mexico', 'Germany', 'Italy', 'Spain', 'France', 'Argentina',
                 'Netherlands', 'Portugal', 'Belgium', 'Uruguay', 'Colombia', 'Croatia',
                 'Sweden', 'Switzerland', 'Poland', 'Denmark', 'Chile', 'Austria',
                 'Turkey', 'Russia', 'Japan', 'South Korea', 'Australia']

    position_detail = ['c', 'c', 'c', 'l', 'r']

    defecit.each do |position, number|
      number.times do
        Player.create(
            name: Faker::Name.last_name,
            age: rand(15..18),
            nationality: countries.sample,
            position:,
            passing: rand(3..4),
            control: rand(3..4),
            tackling: rand(3..4),
            running: rand(3..4),
            shooting: rand(3..4),
            dribbling: rand(3..4),
            defensive_heading: rand(3..4),
            offensive_heading: rand(3..4),
            flair: rand(3..4),
            strength: rand(3..4),
            creativity: rand(3..4),
            fitness: 100,
            contract: rand(13..46),
            club_id:,
            consistency: rand(5..20),
            blend: rand(0..9),
            star: rand(5..30),
            loyalty: rand(10..50),
            player_position_detail: position_detail.sample,
            potential_passing: rand(6..20),
            potential_control: rand(6..20),
            potential_tackling: rand(6..20),
            potential_running: rand(6..20),
            potential_shooting: rand(6..20),
            potential_dribbling: rand(6..20),
            potential_defensive_heading: rand(6..20),
            potential_offensive_heading: rand(6..20),
            potential_flair: rand(6..20),
            potential_strength: rand(6..20),
            potential_creativity: rand(6..20),
            available: 0
          )

        player_total_skill_and_wages
      end
    end
  end

  def player_total_skill_and_wages
    player = [Player.last]
    player_total_skill = Player::Engines::PlayerTotals.new(player, 1).process
    updated_player = Player::Engines::ValueWages.new(player_total_skill, 1).process
    Player.upsert_all(updated_player.to_a.map(&:as_json))
  end
end

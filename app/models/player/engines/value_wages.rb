class Player::Engines::ValueWages
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_value_wages
  end

  private

  def player_value_wages
    players.each do |player|
      player_skill = player.total_skill_calc
      if player_skill < 77
        player.value = player_skill * age_factor(player.age) * 250_000
        player.wages = player_skill * 445
      elsif player_skill < 88
        player.value = player_skill * age_factor(player.age) * 300_000
        player.wages = player_skill * 1025
      elsif player_skill < 99
        player.value = player_skill * age_factor(player.age) * 550_000
        player.wages = player_skill * 1025
      elsif player.total_skill < 110
        player.value = player_skill * age_factor(player.age) * 650_000
        player.wages = player_skill * 1587
      else
        player.value = player_skill * age_factor(player.age) * 750_000
        player.wages = player_skill * 2181
      end
    end
  end

  def age_factor(age)
    case age
    when 18
      1.25
    when 19
      1.2
    when 20
      1.15
    when 21
      1.1
    when 22
      1.05
    when 23
      1
    when 24
      0.95
    when 25
      0.9
    when 26
      0.85
    when 27
      0.8
    when 28
      0.75
    when 29
      0.7
    when 30
      0.65
    when 31
      0.6
    when 32
      0.55
    when 33
      0.5
    when 34
      0.45
    else
      0.4
    end
  end
end

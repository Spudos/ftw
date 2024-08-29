class Player::PlayerUpdates
  attr_reader :week

  Rails.cache.clear

  def initialize(week)
    @week = week
  end

  def call
    process
  end

  private

  def process
    objects = [Player::Engines::Fitness,
               Player::Engines::Contract,
               Player::Engines::Tl,
               Player::Engines::ValueWages,
               Player::Engines::PlayerTotals]

    player_data.in_batches do |batch|
      players = batch.load

      objects.each do |object|
        players = object.new(players, week).process
      end

      attributes = players.to_a.map(&:as_json)
      Player.upsert_all(attributes)
    end
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end

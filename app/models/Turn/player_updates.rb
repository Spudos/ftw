class Turn::PlayerUpdates
  attr_reader :week

  Rails.cache.clear

  def initialize(week)
    @week = week
  end

  def call
    result = Benchmark.bm do |x|
      process(x)
    end
    File.open('measurement.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{r.total}")
      end
    end
  end

  private

  def process(x)
    objects = [Turn::Engines::Fitness,
               Turn::Engines::Contract,
               Turn::Engines::ValueWages,
               Turn::Engines::PlayerTotals]

    player_data.in_batches do |batch|
      players = batch.load

      objects.each do |object|
        object.new(players, week, x).process
      end

      attributes = players.to_a.map(&:as_json)
      Player.upsert_all(attributes)
    end
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end

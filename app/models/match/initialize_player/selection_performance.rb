require 'benchmark'

class Match::InitializePlayer::SelectionPerformance
  attr_reader :selections

  def initialize(selections)
    @selections = selections
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selections.nil?

    selection_performance = []

    player_data = Player.includes(:performances, :goals, :assists, :club).load

    result = Benchmark.bm do |x|
      x.report('build_selection_performance') do
        selections.each do |selection|
          player_id = selection[:player_id]
          player = player_data.find(player_id)

          selection_performance << hash(player, selection)
        end
      end
    end

    File.open('get_selection_performance.log', 'w') do |file|
      result.each do |r|
        file.puts("#{r.label} - #{sprintf('%.6f', r.total)} seconds")
      end
    end

    selection_performance
  end

  private

  def hash(player, selection)
    { club_id: selection[:club_id],
      player_id: player.id,
      name: player.name,
      total_skill: player.total_skill,
      position: player.position,
      position_detail: player.player_position_detail,
      blend: player.blend,
      star: player.star,
      fitness: player.fitness,
      performance: player.match_performance(player) } # runs method
  end
end

class Match::MatchLogging
  attr_reader :minute_by_minute

  def initialize(minute_by_minute)
    @minute_by_minute = minute_by_minute
  end

  def call
    if minute_by_minute.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    filename = "Week_#{minute_by_minute.first[:week]}_MatchId_#{minute_by_minute.first[:id]}_Processed#{Time.now.strftime('%Y%m%d%H%M%S')}"

    match_logging_folder = File.join(Dir.pwd, 'match_logging')

    File.open(File.join(match_logging_folder, "#{filename}.txt"), 'w') do |file|
      file.puts minute_by_minute.first.keys.join(', ')
      minute_by_minute.each do |element|
        file.puts element.values.join(', ')
      end
    end
  end
end

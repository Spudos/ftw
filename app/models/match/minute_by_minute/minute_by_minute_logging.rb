class Match::MinuteByMinute::MinuteByMinuteLogging
  attr_reader :summary, :i

  def initialize(summary, i)
    @summary = summary
    @i = i
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if summary.nil?

    filename = "Processed#{Time.now.strftime('%Y%m%d%H%M%S')}"

    match_logging_folder = File.join(Dir.pwd, 'match_logging')

    sorted = summary.group_by { |element| element[1][0][:club_id] }

    File.open(File.join(match_logging_folder, "#{filename}.txt"), 'w') do |file|
      sorted.each do |element|
        file.puts element
      end
    end
  end
end

class Match::InitializePlayer::SelectionStadium
  attr_reader :selection_star, :fixture_list

  def initialize(selection_star, fixture_list)
    @selection_star = selection_star
    @fixture_list = fixture_list
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selection_star.nil?

    selection_stadium = []

    fixture_list_with_attendance = calculate_attendances(fixture_list)

    selection_star.each do |player|
      player = stadium_effect(player, fixture_list_with_attendance)
      selection_stadium << player
    end

    return selection_stadium
  end

  private

  def calculate_attendances(fixture_list)
    fixture_list_with_attendance = []

    fixture_list.each do |fixture|
binding.pry


    end

    return fixture_list_with_attendance
  end

  def stadium_effect(player, fixture_list_with_attendance)
    if attendance_size <= 10000
      stadium_effect = 0
    elsif attendance_size <= 20000
      stadium_effect = 2
    elsif attendance_size <= 30000
      stadium_effect = 5
    elsif attendance_size <= 40000
      stadium_effect = 8
    elsif attendance_size <= 50000
      stadium_effect = 10
    elsif attendance_size <= 60000
      stadium_effect = 12
    elsif attendance_size <= 70000
      stadium_effect = 15
    else
      stadium_effect = 20
    end
  end
end

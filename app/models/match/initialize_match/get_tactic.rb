class Match::InitializeMatch::GetTactic
  attr_reader :fixture_list

  def initialize(fixture_list)
    @fixture_list = fixture_list
  end

  def call
    club_ids = fixture_list.flat_map { |fixture| [fixture[:club_home], fixture[:club_away]] }
    tactic = []

    club_ids.each do |club|
      tactic_record = Tactic.where(club_id: club)
                            &.pluck(:club_id, :tactics, :dfc_aggression, :mid_aggression, :att_aggression, :press)

      tactic << if tactic_record.present?
                  populate_tactic_list(tactic_record)
                else
                  standard_tactic
                end
    end
  end

  private

  def populate_tactic_list(tactic_record)
    { club_id: tactic_record[0][0],
      tactic: tactic_record[0][1],
      dfc_aggression: tactic_record[0][2],
      mid_aggression: tactic_record[0][3],
      att_aggression: tactic_record[0][4],
      press: tactic_record[0][5] }
  end

  def standard_tactic
    { tactics: 1,
      dfc_aggression: 0,
      mid_aggression: 0,
      att_aggression: 0,
      press: 0 }
  end
end

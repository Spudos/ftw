class Match::InitializeMatch::GetTactics
  attr_reader :fixture_list

  def initialize(fixture_list)
    @fixture_list = fixture_list
  end

  def call
    club_ids = fixture_list.flat_map { |fixture| [fixture[:club_home], fixture[:club_away]] }
    tactics = []

    club_ids.each do |club|
      tactic = Tactic.where(club_id: club)
                     &.pluck(:club_id, :tactics, :dfc_aggression, :mid_aggression, :att_aggression, :press)

      tactics << if tactic.present?
                   { club_id: tactic[0][0],
                     tactics: tactic[0][1],
                     dfc_aggression: tactic[0][2],
                     mid_aggression: tactic[0][3],
                     att_aggression: tactic[0][4],
                     press: tactic[0][5] }
                 else
                   { club_id: club.to_s,
                     tactics: 1,
                     dfc_aggression: 0,
                     mid_aggression: 0,
                     att_aggression: 0,
                     press: 0 }
                 end
    end

    tactics
  end
end

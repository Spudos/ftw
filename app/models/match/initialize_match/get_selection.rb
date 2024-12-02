class Match::InitializeMatch::GetSelection
  attr_reader :fixture_list

  def initialize(fixture_list)
    @fixture_list = fixture_list
  end

  def call
    club_ids = fixture_list.flat_map { |fixture| [fixture[:club_home], fixture[:club_away]] }
    selection = Selection.where(club_id: club_ids)&.pluck(:club_id, :player_id)

    selection.map do |club_id, player_id|
      { club_id:, player_id: }
    end
  end
end

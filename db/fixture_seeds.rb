teams = [
  "alv", "clt", "ema", "fnp", "gcm", "hfk", "imj", "ioz", "kih", "liv",
  "pbh", "qsj", "rct", "slw", "wol", "xwr", "yju", "zep", "zka", "zxn"
]

fixture_list = []
match_id = 1
week_number = 1

(teams.length - 1).times do |week|
  fixtures = []
  teams.each_with_index do |home_team, i|
    teams[i+1..-1].each do |away_team|
      fixture = {
        match_id: match_id,
        week_number: week_number,
        home_team: home_team,
        away_team: away_team,
        comp: "league"
      }
      fixtures << fixture
      match_id += 1
    end
  end
  fixture_list << fixtures
  week_number += 1
  teams.rotate!
end

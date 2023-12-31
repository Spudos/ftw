#load Rails.root.join('db', 'seeds', 'fixture_seeds.rb')

teams = [
  "alv", "clt", "ema", "fnp", "gcm", "hfk", "imj", "ioz", "kih", "liv",
  "pbh", "qsj", "rct", "slw", "wol", "xwr", "yju", "zep", "zka", "zxn"
]

match_id = 1
week_number = 1

teams.each do |home_team|
  teams.each do |away_team|
    next if home_team == away_team

    Fixtures.create!(
      match_id: match_id,
      week_number: week_number,
      home: home_team,
      away: away_team,
      comp: "league"
    )
    match_id += 1
  end
  week_number += 1
end

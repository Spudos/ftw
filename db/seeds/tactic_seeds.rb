def random_number(min, max)
  rand(min..max)
end

(1..240).each do |code|
  Tactic.create(
    club_id: code,
    tactics: random_number(0, 6),
    dfc_aggression: random_number(1, 10),
    mid_aggression: random_number(1, 10),
    att_aggression: random_number(1, 10),
    press: random_number(1, 6)
  )
end

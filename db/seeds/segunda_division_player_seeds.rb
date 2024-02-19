def random_number(min, max)
  rand(min..max)
end

countries = ['Spain', 'Spain', 'Spain', 'Spain', 'Spain', 'Spain', 'Spain', 'Spain', 'Brazil', 'Argentina', 'Germany', 'England', 'France', 'Poland', 'Portugal', 'USA', 'Belgium', 'Mexico', 'Uruguay','Brazil', 'England', 'Mexico', 'Germany', 'Italy', 'Spain', 'France', 'Argentina', 'Netherlands', 'Portugal', 'Belgium', 'Uruguay', 'Colombia', 'Croatia', 'Sweden', 'Switzerland', 'Poland', 'Denmark', 'Chile', 'Austria', 'Turkey', 'Russia', 'Japan', 'South Korea', 'Australia']
position_detail = ['c', 'c', 'c', 'l', 'r']
club_code = [141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160]
blend = [1,2,3,4,5,6,7,8,9]

3.times do
  club_code.each do |code|
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: countries.sample,
      position: 'gkp',
      passing: random_number(3, 6),
      control: random_number(3, 6),
      tackling: random_number(3, 6),
      running: random_number(3, 3),
      shooting: random_number(3, 6),
      dribbling: random_number(3, 4),
      defensive_heading: random_number(3, 4),
      offensive_heading: random_number(3, 6),
      flair: random_number(3, 5),
      strength: random_number(3, 6),
      creativity: random_number(3, 5),
      fitness: 100,
      contract: random_number(3, 24),
      club_id: code,
      consistency: random_number(1, 20),
      loyalty: random_number(1, 50),
      blend: blend.sample,
      star: random_number(10, 30),
      player_position_detail: 'p',
      potential_passing: random_number(8, 15),
      potential_control: random_number(8, 15),
      potential_tackling: random_number(8, 15),
      potential_running: random_number(5, 12),
      potential_shooting: random_number(8, 15),
      potential_dribbling: random_number(5, 12),
      potential_defensive_heading: random_number(5, 12),
      potential_offensive_heading: random_number(8, 15),
      potential_flair: random_number(5, 12),
      potential_strength: random_number(8, 15),
      potential_creativity: random_number(5, 12)
    )
  end
end

7.times do
  club_code.each do |code|
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: countries.sample,
      position: 'dfc',
      passing: random_number(3, 5),
      control: random_number(3, 6),
      tackling: random_number(3, 6),
      running: random_number(3, 6),
      shooting: random_number(3, 5),
      dribbling: random_number(3, 5),
      defensive_heading: random_number(3, 6),
      offensive_heading: random_number(3, 5),
      flair: random_number(3, 5),
      strength: random_number(3, 6),
      creativity: random_number(3, 6),
      fitness: 100,
      contract: random_number(3, 24),
      club_id: code,
      consistency: random_number(1, 20),
      loyalty: random_number(1, 50),
      blend: blend.sample,
      star: random_number(10, 30),
      player_position_detail: position_detail.sample,
      potential_passing: random_number(5, 12),
      potential_control: random_number(8, 15),
      potential_tackling: random_number(8, 15),
      potential_running: random_number(8, 15),
      potential_shooting: random_number(5, 12),
      potential_dribbling: random_number(5, 12),
      potential_defensive_heading: random_number(8, 15),
      potential_offensive_heading: random_number(5, 12),
      potential_flair: random_number(5, 12),
      potential_strength: random_number(8, 15),
      potential_creativity: random_number(8, 15)
    )
  end
end

7.times do
  club_code.each do |code|
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: countries.sample,
      position: 'mid',
      passing: random_number(3, 6),
      control: random_number(3, 6),
      tackling: random_number(3, 5),
      running: random_number(3, 5),
      shooting: random_number(3, 6),
      dribbling: random_number(3, 6),
      defensive_heading: random_number(3, 5),
      offensive_heading: random_number(3, 5),
      flair: random_number(3, 6),
      strength: random_number(3, 5),
      creativity: random_number(3, 6),
      fitness: 100,
      contract: random_number(3, 24),
      club_id: code,
      consistency: random_number(1, 20),
      loyalty: random_number(1, 50),
      blend: blend.sample,
      star: random_number(10, 30),
      player_position_detail: position_detail.sample,
      potential_passing: random_number(8, 15),
      potential_control: random_number(8, 15),
      potential_tackling: random_number(5, 12),
      potential_running: random_number(5, 12),
      potential_shooting: random_number(8, 15),
      potential_dribbling: random_number(8, 15),
      potential_defensive_heading: random_number(5, 12),
      potential_offensive_heading: random_number(5, 12),
      potential_flair: random_number(8, 15),
      potential_strength: random_number(5, 12),
      potential_creativity: random_number(8, 15)
    )
  end
end

6.times do
  club_code.each do |code|
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: countries.sample,
      position: 'att',
      passing: random_number(3, 5),
      control: random_number(6, 7),
      tackling: random_number(3, 5),
      running: random_number(3, 6),
      shooting: random_number(3, 6),
      dribbling: random_number(3, 6),
      defensive_heading: random_number(3, 5),
      offensive_heading: random_number(3, 6),
      flair: random_number(3, 6),
      strength: random_number(3, 5),
      creativity: random_number(3, 5),
      fitness: 100,
      contract: random_number(3, 24),
      club_id: code,
      consistency: random_number(1, 20),
      loyalty: random_number(1, 50),
      blend: blend.sample,
      star: random_number(10, 30),
      player_position_detail: position_detail.sample,
      potential_passing: random_number(5, 12),
      potential_control: random_number(8, 15),
      potential_tackling: random_number(5, 12),
      potential_running: random_number(8, 15),
      potential_shooting: random_number(8, 15),
      potential_dribbling: random_number(8, 15),
      potential_defensive_heading: random_number(5, 12),
      potential_offensive_heading: random_number(8, 15),
      potential_flair: random_number(8, 15),
      potential_strength: random_number(5, 12),
      potential_creativity: random_number(5, 12)
    )
  end
end

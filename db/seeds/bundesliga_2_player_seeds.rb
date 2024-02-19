def random_number(min, max)
  rand(min..max)
end

countries = ['Germany', 'Germany', 'Germany', 'Germany', 'Germany', 'Germany', 'Germany', 'Germany', 'Brazil', 'Argentina', 'Spain', 'England', 'France', 'Poland', 'Portugal', 'USA', 'Belgium', 'Mexico', 'Uruguay','Brazil', 'England', 'Mexico', 'Germany', 'Italy', 'Spain', 'France', 'Argentina', 'Netherlands', 'Portugal', 'Belgium', 'Uruguay', 'Colombia', 'Croatia', 'Sweden', 'Switzerland', 'Poland', 'Denmark', 'Chile', 'Austria', 'Turkey', 'Russia', 'Japan', 'South Korea', 'Australia']
position_detail = ['c', 'c', 'c', 'l', 'r']
club_code = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120]
blend = [1,2,3,4,5,6,7,8,9]

3.times do
  club_code.each do |code|
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: countries.sample,
      position: 'gkp',
      passing: random_number(3, 8),
      control: random_number(3, 8),
      tackling: random_number(3, 8),
      running: random_number(3, 5),
      shooting: random_number(3, 8),
      dribbling: random_number(3, 5),
      defensive_heading: random_number(3, 5),
      offensive_heading: random_number(3, 8),
      flair: random_number(3, 5),
      strength: random_number(3, 8),
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
      control: random_number(3, 8),
      tackling: random_number(3, 8),
      running: random_number(3, 8),
      shooting: random_number(3, 5),
      dribbling: random_number(3, 5),
      defensive_heading: random_number(3, 8),
      offensive_heading: random_number(3, 5),
      flair: random_number(3, 5),
      strength: random_number(3, 8),
      creativity: random_number(3, 8),
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
      passing: random_number(3, 8),
      control: random_number(3, 8),
      tackling: random_number(3, 5),
      running: random_number(3, 5),
      shooting: random_number(3, 8),
      dribbling: random_number(3, 8),
      defensive_heading: random_number(3, 5),
      offensive_heading: random_number(3, 5),
      flair: random_number(3, 8),
      strength: random_number(3, 5),
      creativity: random_number(3, 8),
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
      control: random_number(6, 9),
      tackling: random_number(3, 5),
      running: random_number(3, 8),
      shooting: random_number(3, 8),
      dribbling: random_number(3, 8),
      defensive_heading: random_number(3, 5),
      offensive_heading: random_number(3, 8),
      flair: random_number(3, 8),
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

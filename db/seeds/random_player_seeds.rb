# Define a method to generate a random number between min and max (inclusive)
def random_number(min, max)
  rand(min..max)
end

uk_countries = ['England', 'England', 'England', 'England', 'Scotland', 'Wales', 'NI', 'RoI']
position_detail = ['c', 'c', 'l', 'r']

300.times do
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: uk_countries.sample,
      position: 'gkp',
      passing: random_number(3, 9),
      control: random_number(3, 9),
      tackling: random_number(3, 9),
      running: random_number(3, 6),
      shooting: random_number(3, 9),
      dribbling: random_number(3, 6),
      defensive_heading: random_number(3, 6),
      offensive_heading: random_number(3, 9),
      flair: random_number(3, 6),
      strength: random_number(3, 9),
      creativity: random_number(3, 6),
      fitness: 100,
      consistency: 20,
      player_position_detail: 'p',
      potential_passing: random_number(9, 15),
      potential_control: random_number(9, 15),
      potential_tackling: random_number(9, 15),
      potential_running: random_number(6, 12),
      potential_shooting: random_number(9, 15),
      potential_dribbling: random_number(6, 12),
      potential_defensive_heading: random_number(6, 12),
      potential_offensive_heading: random_number(9, 15),
      potential_flair: random_number(6, 12),
      potential_strength: random_number(9, 15),
      potential_creativity: random_number(6, 12)
    )
  end

600.times do
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: uk_countries.sample,
      position: 'dfc',
      passing: random_number(3, 6),
      control: random_number(3, 9),
      tackling: random_number(3, 9),
      running: random_number(3, 9),
      shooting: random_number(3, 6),
      dribbling: random_number(3, 6),
      defensive_heading: random_number(3, 9),
      offensive_heading: random_number(3, 6),
      flair: random_number(3, 6),
      strength: random_number(3, 9),
      creativity: random_number(3, 9),
      fitness: 100,
      consistency: 20,
      player_position_detail: position_detail.sample,
      potential_passing: random_number(6, 12),
      potential_control: random_number(9, 15),
      potential_tackling: random_number(9, 15),
      potential_running: random_number(9, 15),
      potential_shooting: random_number(6, 12),
      potential_dribbling: random_number(6, 12),
      potential_defensive_heading: random_number(9, 15),
      potential_offensive_heading: random_number(6, 12),
      potential_flair: random_number(6, 12),
      potential_strength: random_number(9, 15),
      potential_creativity: random_number(9, 15)
    )
  end

600.times do
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: uk_countries.sample,
      position: 'mid',
      passing: random_number(3, 9),
      control: random_number(3, 9),
      tackling: random_number(3, 6),
      running: random_number(3, 6),
      shooting: random_number(3, 9),
      dribbling: random_number(3, 9),
      defensive_heading: random_number(3, 6),
      offensive_heading: random_number(3, 6),
      flair: random_number(3, 9),
      strength: random_number(3, 6),
      creativity: random_number(3, 9),
      fitness: 100,
      consistency: 20,
      player_position_detail: position_detail.sample,
      potential_passing: random_number(9, 15),
      potential_control: random_number(9, 15),
      potential_tackling: random_number(6, 12),
      potential_running: random_number(6, 12),
      potential_shooting: random_number(9, 15),
      potential_dribbling: random_number(9, 15),
      potential_defensive_heading: random_number(6, 12),
      potential_offensive_heading: random_number(6, 12),
      potential_flair: random_number(9, 15),
      potential_strength: random_number(6, 12),
      potential_creativity: random_number(9, 15)
    )
  end

500.times do
    Player.create(
      name: Faker::Name.last_name,
      age: random_number(18, 35),
      nationality: uk_countries.sample,
      position: 'att',
      passing: random_number(3, 6),
      control: random_number(6, 9),
      tackling: random_number(3, 6),
      running: random_number(3, 9),
      shooting: random_number(3, 9),
      dribbling: random_number(3, 9),
      defensive_heading: random_number(3, 6),
      offensive_heading: random_number(3, 9),
      flair: random_number(3, 9),
      strength: random_number(3, 6),
      creativity: random_number(3, 6),
      fitness: 100,
      consistency: 20,
      player_position_detail: position_detail.sample,
      potential_passing: random_number(6, 12),
      potential_control: random_number(9, 15),
      potential_tackling: random_number(6, 12),
      potential_running: random_number(9, 15),
      potential_shooting: random_number(9, 15),
      potential_dribbling: random_number(9, 15),
      potential_defensive_heading: random_number(6, 12),
      potential_offensive_heading: random_number(9, 15),
      potential_flair: random_number(9, 15),
      potential_strength: random_number(6, 12),
      potential_creativity: random_number(6, 12)
    )
  end

# Define a method to generate a random number between min and max (inclusive)
def random_number(min, max)
  rand(min..max)
end

# Create players with random stats for each position
20.times do
  Player.create(
    name: Faker::Name.name,
    age: random_number(18, 35),
    nationality: Faker::Nation.nationality,
    pos: 'gkp',
    pa: random_number(3, 7),
    co: random_number(3, 8),
    ta: random_number(3, 5),
    ru: random_number(3, 8),
    sh: random_number(3, 9),
    dr: random_number(3, 7),
    df: random_number(3, 5),
    of: random_number(3, 8),
    fl: random_number(3, 8),
    st: random_number(3, 8),
    cr: random_number(3, 8),
    fit: 100
  )
end

50.times do
  Player.create(
    name: Faker::Name.name,
    age: random_number(18, 35),
    nationality: Faker::Nation.nationality,
    pos: 'def',
    pa: random_number(3, 6),
    co: random_number(3, 8),
    ta: random_number(3, 9),
    ru: random_number(3, 9),
    sh: random_number(3, 5),
    dr: random_number(3, 5),
    df: random_number(3, 10),
    of: random_number(3, 6),
    fl: random_number(3, 6),
    st: random_number(3, 10),
    cr: random_number(3, 8),
    fit: 100
  )
end

50.times do
  Player.create(
    name: Faker::Name.name,
    age: random_number(18, 35),
    nationality: Faker::Nation.nationality,
    pos: 'mid',
    pa: random_number(3, 9),
    co: random_number(3, 8),
    ta: random_number(3, 6),
    ru: random_number(3, 8),
    sh: random_number(3, 7),
    dr: random_number(3, 7),
    df: random_number(3, 6),
    of: random_number(3, 6),
    fl: random_number(3, 8),
    st: random_number(3, 8),
    cr: random_number(3, 8),
    fit: 100
  )
end

50.times do
  Player.create(
    name: Faker::Name.name,
    age: random_number(18, 35),
    nationality: Faker::Nation.nationality,
    pos: 'att',
    pa: random_number(3, 7),
    co: random_number(3, 8),
    ta: random_number(3, 5),
    ru: random_number(3, 8),
    sh: random_number(3, 9),
    dr: random_number(3, 7),
    df: random_number(3, 5),
    of: random_number(3, 8),
    fl: random_number(3, 8),
    st: random_number(3, 8),
    cr: random_number(3, 8),
    fit: 100
  )
end
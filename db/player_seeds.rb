# Define a method to generate a random number between min and max (inclusive)
def random_number(min, max)
  rand(min..max)
end

uk_countries = ['England', 'England', 'England', 'England', 'Scotland', 'Wales', 'Nothern Ireland', 'Republic of Ireland']

def generate_random_code
  ('aaa'..'zzz').to_a.sample
end

positions = ['gkp', 'dfc', 'mid', 'att']
position_counts = [3, 6, 6, 5]

codes = (1..500).map { generate_random_code }

codes.each do |code|
  position_counts.each_with_index do |count, index|
    count.times do
      Player.create(
        name: Faker::Name.last_name,
        age: random_number(18, 35),
        nationality: uk_countries.sample,
        pos: positions[index],
        pa: random_number(3, 9),
        co: random_number(3, 8),
        ta: random_number(3, 6),
        ru: random_number(3, 9),
        sh: random_number(3, 9),
        dr: random_number(3, 9),
        df: random_number(3, 9),
        of: random_number(3, 9),
        fl: random_number(3, 9),
        st: random_number(3, 9),
        cr: random_number(3, 9),
        fit: 100,
        club: code,
        cons: 20
      )
    end
  end
end

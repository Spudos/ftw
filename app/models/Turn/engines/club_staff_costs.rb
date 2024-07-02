class Turn::Engines::ClubStaffCosts
  attr_reader :week, :club

  def initialize(week, club)
    @week = week
    @club = club
    @club_messages = []
  end

  def process
    action_id = "#{week}#{club.id}upkeep"

    staff_costs_total = ((club.staff_gkp +
                          club.staff_dfc +
                          club.staff_mid +
                          club.staff_att +
                          club.staff_fitness +
                          club.staff_scouts)) * rand(9234..11234)

    new_bal = club.bank_bal.to_i - staff_costs_total.to_i
    club.update(bank_bal: new_bal)

    @club_messages << { action_id:,
                        week:,
                        club_id: club.id,
                        var1: "Your bank account was charged with #{staff_costs_total} due to this weeks staff wages",
                        var2: 'dec-staff_wages',
                        var3: staff_costs_total }
  end
end

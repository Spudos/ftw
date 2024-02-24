class Turn::ClubUpdates
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    wage_bill
    staff_costs
    ground_upkeep
  end

  private

  def wage_bill
    clubs = Club.all
    clubs.each do |club|
      action_id = week.to_s + club.id.to_s + 'wage'

      wage_bill = Player.where(club_id: club.id).sum(:wages)

      new_bal = club.bank_bal.to_i - wage_bill.to_i
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was charged with #{wage_bill} due to this weeks player wages", var2: 'payment', var3: wage_bill)
    end

    def staff_costs
      clubs = Club.all
      clubs.each do |club|
        action_id = week.to_s + club.id.to_s + 'upkeep'

        staff_costs_total = ((club.staff_gkp + club.staff_dfc + club.staff_mid + club.staff_att + club.staff_fitness + club.staff_scouts)) * rand(9234..11234)

        new_bal = club.bank_bal.to_i - staff_costs_total.to_i
        club.update(bank_bal: new_bal)

        Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was charged with #{staff_costs_total} due to this weeks staff wages", var2: 'payment', var3: staff_costs_total)
      end
    end
  end

  def ground_upkeep
    clubs = Club.all
    clubs.each do |club|
      action_id = week.to_s + club.id.to_s + 'upkeep'

      stadium_cost = ((club.stand_n_capacity * club.stand_n_condition) + (club.stand_s_capacity * club.stand_s_condition) + (club.stand_e_capacity * club.stand_e_condition) + (club.stand_w_capacity * club.stand_w_condition)) * 6
      pitch_cost = club.pitch * rand(4545..5234)
      facilities_cost = club.facilities * rand(4545..5234)
      hospitality_cost = club.hospitality * rand(4545..5234)

      ground_upkeep_total = stadium_cost + pitch_cost + facilities_cost + hospitality_cost

      new_bal = club.bank_bal.to_i - ground_upkeep_total.to_i
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was charged with #{ground_upkeep_total} due to this weeks stadium upkeep", var2: 'payment', var3: ground_upkeep_total)
    end
  end
end

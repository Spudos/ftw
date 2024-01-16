class Turnsheet < ApplicationRecord
  def process_turnsheet
    Turnsheet.find_each do |turnsheet|
      next if turnsheet.processed.present?

      turnsheet.save # Save the Turnsheet record first
      
      Selection.where(club: turnsheet.club).destroy_all

      (1..11).each do |i|
        Selection.create(club: turnsheet.club, player_id: turnsheet.send("player_#{i}"))
      end

      tactic_record = Tactic.find_by(abbreviation: turnsheet.club)

      if tactic_record
        tactic_record.destroy # Remove the existing tactic entry
      end

      if turnsheet.tactic.nil?
        Tactic.create(abbreviation: turnsheet.club, tactics: 1)
      else
        Tactic.create(abbreviation: turnsheet.club, tactics: turnsheet.tactic)
      end

      if turnsheet.coach_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'coach', var2: turnsheet.coach_upgrade, var3: 500000 })
      end

      if turnsheet.property_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'property', var2: turnsheet.property_upgrade, var3: 250000 })
      end

      if turnsheet.train_goalkeeper.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_goalkeeper, var3: turnsheet.train_goalkeeper_skill })
      end

      if turnsheet.train_defender.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_defender, var3: turnsheet.train_defender_skill })
      end

      if turnsheet.train_midfielder.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_midfielder, var3: turnsheet.train_midfielder_skill })
      end

      if turnsheet.train_attacker.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_attacker, var3: turnsheet.train_attacker_skill })
      end

      if turnsheet.stadium_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: turnsheet.stadium_upgrade, var2: turnsheet.stadium_amount, var3: turnsheet.val })
      end

      if turnsheet.stadium_condition_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: turnsheet.stadium_condition_upgrade, var3: 100000 })
      end

      turnsheet.update(processed: DateTime.now)
    rescue StandardError => e
      errors.add(:base, "Error processing turnsheet with ID #{turnsheet.id}: #{e.message}")
    end
  end
end

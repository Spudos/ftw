class Turnsheet < ApplicationRecord
  has_many :selections
  has_many :upgrades
  has_many :turns

  def process_turnsheet
    Turnsheet.find_each do |turnsheet|
      next if turnsheet.processed.present?

      turnsheet.save # Save the Turnsheet record first

      Selection.where(club: turnsheet.club).destroy_all

      (1..11).each do |i|
        Selection.create(club: turnsheet.club, player_id: turnsheet.send("player_#{i}"), turnsheet: turnsheet)
      end

      if turnsheet.coach_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'coach', var2: turnsheet.coach_upgrade, var3: 500000, turnsheet: turnsheet })
      end

      if turnsheet.property_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'property', var2: turnsheet.property_upgrade, var3: 250000, turnsheet: turnsheet })
      end

      if turnsheet.train_goalkeeper.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_goalkeeper, var3: turnsheet.train_goalkeeper_skill, turnsheet: turnsheet })
      end

      if turnsheet.train_defender.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_defender, var3: turnsheet.train_defender_skill, turnsheet: turnsheet })
      end

      if turnsheet.train_midfielder.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_midfielder, var3: turnsheet.train_midfielder_skill, turnsheet: turnsheet })
      end
  
      if turnsheet.train_attacker.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_attacker, var3: turnsheet.train_attacker_skill, turnsheet: turnsheet })
      end

      if turnsheet.stadium_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: turnsheet.stadium_upgrade, var2: turnsheet.stadium_amount, var3: turnsheet.val, turnsheet: turnsheet })
      end
  
      if turnsheet.stadium_condition_upgrade.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: turnsheet.stadium_condition_upgrade, var3: 100000, turnsheet: turnsheet })
      end

      turnsheet.update(processed: DateTime.now)
    rescue StandardError => e
      errors << "Error processing turnsheet with ID #{turnsheet.id}: #{e.message}"
    end
  end
end

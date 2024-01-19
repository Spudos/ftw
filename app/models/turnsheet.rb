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

      if turnsheet.dfc_aggression.nil?
        Tactic.find_by(abbreviation: turnsheet.club).update(dfc_aggression: 0)
      else
        Tactic.find_by(abbreviation: turnsheet.club).update(dfc_aggression: turnsheet.dfc_aggression)
      end

      if turnsheet.mid_aggression.nil?
        Tactic.find_by(abbreviation: turnsheet.club).update(mid_aggression: 0)
      else
        Tactic.find_by(abbreviation: turnsheet.club).update(mid_aggression: turnsheet.mid_aggression)
      end

      if turnsheet.att_aggression.nil?
        Tactic.find_by(abbreviation: turnsheet.club).update(att_aggression: 0)
      else
        Tactic.find_by(abbreviation: turnsheet.club).update(att_aggression: turnsheet.att_aggression)
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

      if turnsheet.fitness_coaching.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'fitness', var2: turnsheet.fitness_coaching })
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

#------------------------------------------------------------------------------
# Turnsheet
#
# Name                      SQL Type             Null    Primary Default
# ------------------------- -------------------- ------- ------- ----------
# id                        INTEGER              false   true              
# week                      INTEGER              true    false             
# club                      varchar              true    false             
# manager                   varchar              true    false             
# email                     varchar              true    false             
# player_1                  varchar              true    false             
# player_2                  varchar              true    false             
# player_3                  varchar              true    false             
# player_4                  varchar              true    false             
# player_5                  varchar              true    false             
# player_6                  varchar              true    false             
# player_7                  varchar              true    false             
# player_8                  varchar              true    false             
# player_9                  varchar              true    false             
# player_10                 varchar              true    false             
# player_11                 varchar              true    false             
# stadium_upgrade           varchar              true    false             
# coach_upgrade             varchar              true    false             
# train_goalkeeper          varchar              true    false             
# train_goalkeeper_skill    varchar              true    false             
# train_defender            varchar              true    false             
# train_defender_skill      varchar              true    false             
# train_midfielder          varchar              true    false             
# train_midfielder_skill    varchar              true    false             
# train_attacker            varchar              true    false             
# train_attacker_skill      varchar              true    false             
# created_at                datetime(6)          false   false             
# updated_at                datetime(6)          false   false             
# stadium_amount            INTEGER              true    false             
# processed                 datetime(6)          true    false             
# val                       INTEGER              true    false             
# property_upgrade          varchar              true    false             
# stadium_condition_upgrade varchar              true    false             
# tactic                    INTEGER              true    false             
# dfc_aggression            INTEGER              true    false             
# mid_aggression            INTEGER              true    false             
# att_aggression            INTEGER              true    false             
# fitness_coaching          varchar              true    false             
#
#------------------------------------------------------------------------------

class Turnsheet < ApplicationRecord
  def process_turnsheet
    Turnsheet.find_each do |turnsheet|
      next if turnsheet.processed.present?

      turnsheet.save

      Selection.where(club_id: turnsheet.club_id).destroy_all

      (1..11).each do |i|
        Selection.create(club_id: turnsheet.club_id, player_id: turnsheet.send("player_#{i}"))
      end

      tactic_record = Tactic.find_by(club_id: turnsheet.club_id)

      if tactic_record
        tactic_record.destroy
      end

      if turnsheet.tactic.nil?
        Tactic.create(club_id: turnsheet.club_id, tactics: 0)
      else
        Tactic.create(club_id: turnsheet.club_id, tactics: turnsheet.tactic)
      end

      if turnsheet.press.nil?
        Tactic.find_by(club_id: turnsheet.club_id).update(press: 0)
      else
        Tactic.find_by(club_id: turnsheet.club_id).update(press: turnsheet.press)
      end

      if turnsheet.dfc_aggression.nil?
        Tactic.find_by(club_id: turnsheet.club_id).update(dfc_aggression: 0)
      else
        Tactic.find_by(club_id: turnsheet.club_id).update(dfc_aggression: turnsheet.dfc_aggression)
      end

      if turnsheet.mid_aggression.nil?
        Tactic.find_by(club_id: turnsheet.club_id).update(mid_aggression: 0)
      else
        Tactic.find_by(club_id: turnsheet.club_id).update(mid_aggression: turnsheet.mid_aggression)
      end

      if turnsheet.att_aggression.nil?
        Tactic.find_by(club_id: turnsheet.club_id).update(att_aggression: 0)
      else
        Tactic.find_by(club_id: turnsheet.club_id).update(att_aggression: turnsheet.att_aggression)
      end

      if turnsheet.coach_upgrade.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'coach', var2: turnsheet.coach_upgrade, var3: 500_000 })
      end

      if turnsheet.property_upgrade.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'property', var2: turnsheet.property_upgrade, var3: 250_000 })
      end

      if turnsheet.train_goalkeeper.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'train', var2: turnsheet.train_goalkeeper, var3: turnsheet.train_goalkeeper_skill })
      end

      if turnsheet.train_defender.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'train', var2: turnsheet.train_defender, var3: turnsheet.train_defender_skill })
      end

      if turnsheet.train_midfielder.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'train', var2: turnsheet.train_midfielder, var3: turnsheet.train_midfielder_skill })
      end

      if turnsheet.train_attacker.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'train', var2: turnsheet.train_attacker, var3: turnsheet.train_attacker_skill })
      end

      if turnsheet.fitness_coaching.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: 'fitness', var2: turnsheet.fitness_coaching })
      end

      if turnsheet.stadium_upgrade.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.stadium_upgrade, var2: turnsheet.stadium_amount, var3: turnsheet.val })
      end

      if turnsheet.stadium_condition_upgrade.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.stadium_condition_upgrade, var3: 100_000 })
      end

      if turnsheet.transfer_type.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.transfer_type, var2: turnsheet.transfer_player_id,
                      var3: turnsheet.transfer_amount, var4: turnsheet.transfer_club })
      end

      if turnsheet.transfer1_type.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.transfer1_type, var2: turnsheet.transfer1_player_id,
                      var3: turnsheet.transfer1_amount, var4: turnsheet.transfer1_club })
      end

      if turnsheet.transfer2_type.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.transfer2_type, var2: turnsheet.transfer2_player_id,
                      var3: turnsheet.transfer2_amount, var4: turnsheet.transfer2_club })
      end

      if turnsheet.transfer3_type.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.transfer3_type, var2: turnsheet.transfer3_player_id,
                      var3: turnsheet.transfer3_amount, var4: turnsheet.transfer3_club })
      end

      if turnsheet.player_action_1.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.player_action_1, var2: turnsheet.player_action_1_player_id,
                      var3: turnsheet.player_action_1_var })
      end

      if turnsheet.player_action_2.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.player_action_2, var2: turnsheet.player_action_2_player_id,
                      var3: turnsheet.player_action_2_var })
      end

      if turnsheet.player_action_3.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.player_action_3, var2: turnsheet.player_action_3_player_id,
                      var3: turnsheet.player_action_3_var })
      end

      if turnsheet.player_action_4.present?
        Turn.create({ week: turnsheet.week, club_id: turnsheet.club_id,
                      var1: turnsheet.player_action_4, var2: turnsheet.player_action_4_player_id,
                      var3: turnsheet.player_action_4_var })
      end

      if turnsheet.article_headline.present?
        create_article(turnsheet.week, turnsheet.club_id, turnsheet.article_headline,
                       turnsheet.article_sub_headline, turnsheet.article)
      end

      if turnsheet.club_message.present?
        Message.create(week: turnsheet.week,
                       club_id: turnsheet.club_message,
                       var1: "Message from #{Club.find_by(id: turnsheet.club_id)&.name} - #{turnsheet.message_text}",
                       var2: 'private',
                       action_id: "#{turnsheet.week}#{turnsheet.club_id}clubmessage")
      end

      if turnsheet.public_message.present?
        Message.create(week: turnsheet.week,
                       club_id: turnsheet.club_id,
                       var1: turnsheet.public_message,
                       var2: 'public',
                       action_id: "#{turnsheet.week}#{turnsheet.club_id}publicmessage")
      end

      begin
        turnsheet.update(processed: DateTime.now)
      rescue StandardError => e
        errors << "Error processing turnsheet: #{e.message}"
      end
    end

    errors.empty? ? true : errors
  end

  private

  def create_article(week, club_id, headline, sub_headline, article)
    Article.create(week:, club_id:, image: 'club.jpg', article_type: 'club', headline:, sub_headline:, article:)
    action_id = "#{week}#{club_id}media"
    club = Club.find_by(id: club_id)
    club.bank_bal = club.bank_bal += 1_000_000
    club.save

    Message.create(
      week:,
      club_id:,
      var1: 'Your bank account has been credited with 1000000 from a sports channel for your media duties',
      var2: 'inc-other',
      action_id:,
      var3: 1_000_000
    )
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

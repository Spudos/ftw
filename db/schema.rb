# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_05_222557) do
  create_table "articles", force: :cascade do |t|
    t.integer "week"
    t.integer "club_id"
    t.string "image"
    t.string "article_type"
    t.string "headline"
    t.string "sub_headline"
    t.string "article"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ground_name"
    t.string "stand_n_name"
    t.integer "stand_n_condition"
    t.integer "stand_n_capacity"
    t.string "stand_s_name"
    t.integer "stand_s_condition"
    t.integer "stand_s_capacity"
    t.string "stand_e_name"
    t.integer "stand_e_condition"
    t.integer "stand_e_capacity"
    t.string "stand_w_name"
    t.integer "stand_w_condition"
    t.integer "stand_w_capacity"
    t.integer "pitch"
    t.integer "hospitality"
    t.integer "facilities"
    t.integer "staff_fitness"
    t.integer "staff_gkp"
    t.integer "staff_dfc"
    t.integer "staff_mid"
    t.integer "staff_att"
    t.integer "staff_scouts"
    t.string "color_primary"
    t.string "color_secondary"
    t.integer "bank_bal"
    t.boolean "managed"
    t.string "league"
    t.integer "fan_happiness", default: 53
    t.integer "fanbase", default: 40980
    t.integer "ticket_price"
    t.integer "overdrawn", default: 0
  end

  create_table "commentaries", force: :cascade do |t|
    t.string "match_id"
    t.integer "minute"
    t.text "commentary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event"
    t.integer "home_score"
    t.integer "away_score"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "club"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feedback_type"
    t.boolean "outstanding"
  end

  create_table "fixtures", force: :cascade do |t|
    t.integer "week_number"
    t.string "home"
    t.string "away"
    t.string "comp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer "match_id"
    t.integer "week_number"
    t.integer "minute"
    t.integer "assist_id"
    t.integer "scorer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "competition"
  end

  create_table "leagues", force: :cascade do |t|
    t.integer "club_id"
    t.integer "played"
    t.integer "won"
    t.integer "drawn"
    t.integer "lost"
    t.integer "goals_for"
    t.integer "goals_against"
    t.integer "goal_difference"
    t.integer "points"
    t.string "competition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "match_id"
    t.string "home_team"
    t.string "away_team"
    t.integer "home_possession"
    t.integer "away_possession"
    t.integer "home_chance"
    t.integer "away_chance"
    t.integer "home_chance_on_target"
    t.integer "away_chance_on_target"
    t.string "home_man_of_the_match"
    t.string "away_man_of_the_match"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_goals"
    t.integer "away_goals"
    t.integer "week_number"
    t.integer "tactic_home"
    t.integer "tactic_away"
    t.string "competition"
    t.integer "dfc_aggression_home"
    t.integer "mid_aggression_home"
    t.integer "att_aggression_home"
    t.integer "dfc_aggression_away"
    t.integer "mid_aggression_away"
    t.integer "att_aggression_away"
    t.integer "dfc_blend_home"
    t.integer "mid_blend_home"
    t.integer "att_blend_home"
    t.integer "dfc_blend_away"
    t.integer "mid_blend_away"
    t.integer "att_blend_away"
    t.integer "home_press"
    t.integer "away_press"
    t.integer "attendance"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "week"
    t.string "club_id"
    t.string "var1"
    t.string "var2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_id"
    t.integer "var3"
  end

  create_table "performances", force: :cascade do |t|
    t.integer "match_id"
    t.integer "player_id"
    t.string "club_id"
    t.string "name"
    t.string "player_position"
    t.string "player_position_detail"
    t.integer "match_performance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "competition"
  end

  create_table "pl_statistics", force: :cascade do |t|
    t.integer "player_id"
    t.integer "man_of_the_match"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "match_id"
    t.boolean "goal"
    t.boolean "assist"
    t.integer "time"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "nationality"
    t.string "position"
    t.integer "passing"
    t.integer "control"
    t.integer "tackling"
    t.integer "running"
    t.integer "shooting"
    t.integer "dribbling"
    t.integer "defensive_heading"
    t.integer "offensive_heading"
    t.integer "flair"
    t.integer "strength"
    t.integer "creativity"
    t.integer "fitness"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "consistency"
    t.integer "potential_passing"
    t.integer "potential_control"
    t.integer "potential_tackling"
    t.integer "potential_running"
    t.integer "potential_shooting"
    t.integer "potential_dribbling"
    t.integer "potential_defensive_heading"
    t.integer "potential_offensive_heading"
    t.integer "potential_flair"
    t.integer "potential_strength"
    t.integer "potential_creativity"
    t.string "player_position_detail"
    t.integer "blend"
    t.integer "contract", default: 24
    t.integer "star"
    t.integer "club_id"
    t.integer "value", default: 0, null: false
    t.integer "wages", default: 0, null: false
    t.text "parent"
    t.integer "loyalty"
    t.integer "total_skill", default: 0, null: false
    t.integer "games_played", default: 0, null: false
    t.integer "total_goals", default: 0, null: false
    t.integer "total_assists", default: 0, null: false
    t.integer "average_performance", default: 0, null: false
    t.boolean "listed"
    t.boolean "potential_passing_coached", default: false
    t.boolean "potential_control_coached", default: false
    t.boolean "potential_tackling_coached", default: false
    t.boolean "potential_running_coached", default: false
    t.boolean "potential_shooting_coached", default: false
    t.boolean "potential_dribbling_coached", default: false
    t.boolean "potential_defensive_heading_coached", default: false
    t.boolean "potential_offensive_heading_coached", default: false
    t.boolean "potential_flair_coached", default: false
    t.boolean "potential_strength_coached", default: false
    t.boolean "potential_creativity_coached", default: false
    t.integer "available"
  end

  create_table "selections", force: :cascade do |t|
    t.string "club_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tactics", force: :cascade do |t|
    t.string "club_id"
    t.integer "tactics", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dfc_aggression", default: 0, null: false
    t.integer "mid_aggression", default: 0, null: false
    t.integer "att_aggression", default: 0, null: false
    t.integer "press", default: 0, null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "commentary_type"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "player_id"
    t.integer "sell_club"
    t.integer "buy_club"
    t.integer "week"
    t.integer "bid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "turns", force: :cascade do |t|
    t.integer "week"
    t.string "club_id"
    t.string "var1"
    t.string "var2"
    t.string "var3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_completed"
    t.string "var4"
  end

  create_table "turnsheets", force: :cascade do |t|
    t.integer "week"
    t.string "club_id"
    t.string "manager"
    t.string "email"
    t.string "player_1"
    t.string "player_2"
    t.string "player_3"
    t.string "player_4"
    t.string "player_5"
    t.string "player_6"
    t.string "player_7"
    t.string "player_8"
    t.string "player_9"
    t.string "player_10"
    t.string "player_11"
    t.string "stadium_upgrade"
    t.string "coach_upgrade"
    t.string "train_goalkeeper"
    t.string "train_goalkeeper_skill"
    t.string "train_defender"
    t.string "train_defender_skill"
    t.string "train_midfielder"
    t.string "train_midfielder_skill"
    t.string "train_attacker"
    t.string "train_attacker_skill"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stadium_amount"
    t.datetime "processed"
    t.integer "val"
    t.string "property_upgrade"
    t.string "stadium_condition_upgrade"
    t.integer "tactic"
    t.integer "dfc_aggression"
    t.integer "mid_aggression"
    t.integer "att_aggression"
    t.string "fitness_coaching"
    t.integer "press"
    t.integer "transfer_player_id"
    t.integer "transfer_amount"
    t.string "transfer_type"
    t.string "transfer1_type"
    t.integer "transfer1_player_id"
    t.integer "transfer1_amount"
    t.string "transfer2_type"
    t.integer "transfer2_player_id"
    t.integer "transfer2_amount"
    t.string "transfer3_type"
    t.integer "transfer3_player_id"
    t.integer "transfer3_amount"
    t.string "player_action_1"
    t.integer "player_action_1_player_id"
    t.string "player_action_1_var"
    t.string "player_action_2"
    t.integer "player_action_2_player_id"
    t.string "player_action_2_var"
    t.string "player_action_3"
    t.integer "player_action_3_player_id"
    t.string "player_action_3_var"
    t.string "player_action_4"
    t.integer "player_action_4_player_id"
    t.string "player_action_4_var"
    t.string "transfer_club"
    t.string "transfer1_club"
    t.string "transfer2_club"
    t.string "transfer3_club"
    t.string "article_headline"
    t.string "article_sub_headline"
    t.string "article"
    t.integer "club_message"
    t.string "message_text"
    t.string "public_message"
  end

  create_table "upgrades", force: :cascade do |t|
    t.integer "week"
    t.string "club_id"
    t.string "var1"
    t.string "var2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "var3"
    t.string "action_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fname"
    t.string "lname"
    t.integer "club"
    t.integer "club_count", default: 0
    t.date "appointed"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "pl_statistics", "players"
end

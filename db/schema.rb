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

ActiveRecord::Schema[7.0].define(version: 2024_01_09_140332) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
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
    t.string "manager"
    t.string "manager_email"
  end

  create_table "commentaries", force: :cascade do |t|
    t.string "game_id"
    t.integer "minute"
    t.text "commentary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event"
    t.integer "home_score"
    t.integer "away_score"
  end

  create_table "fixtures", force: :cascade do |t|
    t.integer "match_id"
    t.integer "week_number"
    t.string "home"
    t.string "away"
    t.string "comp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "match_id"
    t.string "hm_team"
    t.string "aw_team"
    t.integer "hm_poss"
    t.integer "aw_poss"
    t.integer "hm_cha"
    t.integer "aw_cha"
    t.integer "hm_cha_on_tar"
    t.integer "aw_cha_on_tar"
    t.string "hm_motm"
    t.string "aw_motm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hm_goal"
    t.integer "aw_goal"
    t.integer "week_number"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "week"
    t.string "club"
    t.string "var1"
    t.string "var2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_id"
  end

  create_table "pl_matches", force: :cascade do |t|
    t.integer "match_id"
    t.integer "player_id"
    t.integer "match_perf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pl_stats", force: :cascade do |t|
    t.integer "player_id"
    t.integer "motm"
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
    t.string "pos"
    t.integer "pa"
    t.integer "co"
    t.integer "ta"
    t.integer "ru"
    t.integer "sh"
    t.integer "dr"
    t.integer "df"
    t.integer "of"
    t.integer "fl"
    t.integer "st"
    t.integer "cr"
    t.integer "fit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "club"
    t.integer "cons"
    t.integer "pot_pa"
    t.integer "pot_co"
    t.integer "pot_ta"
    t.integer "pot_ru"
    t.integer "pot_sh"
    t.integer "pot_dr"
    t.integer "pot_df"
    t.integer "pot_of"
    t.integer "pot_fl"
    t.integer "pot_st"
    t.integer "pot_cr"
  end

  create_table "selections", force: :cascade do |t|
    t.string "club"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "commentary_type"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turns", force: :cascade do |t|
    t.integer "week"
    t.string "club"
    t.string "var1"
    t.string "var2"
    t.string "var3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_completed"
  end

  create_table "turnsheets", force: :cascade do |t|
    t.integer "week"
    t.string "club"
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
    t.string "stad_upg"
    t.string "coach_upg"
    t.string "train_gkp"
    t.string "train_gkp_skill"
    t.string "train_dfc"
    t.string "train_dfc_skill"
    t.string "train_mid"
    t.string "train_mid_skill"
    t.string "train_att"
    t.string "train_att_skill"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stad_amt"
    t.datetime "processed"
    t.integer "val"
    t.string "prop_upg"
    t.string "stad_cond_upg"
  end

  create_table "upgrades", force: :cascade do |t|
    t.integer "week"
    t.string "club"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "pl_matches", "players"
  add_foreign_key "pl_stats", "players"
end

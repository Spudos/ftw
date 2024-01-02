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

ActiveRecord::Schema[7.0].define(version: 2024_01_02_201515) do
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
    t.string "pitch"
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

  add_foreign_key "pl_matches", "players"
  add_foreign_key "pl_stats", "players"
end

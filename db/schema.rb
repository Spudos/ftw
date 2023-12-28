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

ActiveRecord::Schema[7.0].define(version: 2023_12_28_172733) do
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
  end

end

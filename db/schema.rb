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

ActiveRecord::Schema[7.2].define(version: 2024_01_01_000004) do
  create_table "standup_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
    t.date "entry_date", null: false
    t.text "yesterday", null: false
    t.text "today", null: false
    t.text "blockers"
    t.boolean "has_blockers", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "entry_date"], name: "index_standup_entries_on_team_id_and_entry_date"
    t.index ["team_id"], name: "index_standup_entries_on_team_id"
    t.index ["user_id", "entry_date"], name: "index_standup_entries_on_user_id_and_entry_date", unique: true
    t.index ["user_id"], name: "index_standup_entries_on_user_id"
  end

  create_table "standup_summaries", force: :cascade do |t|
    t.integer "team_id", null: false
    t.date "summary_date", null: false
    t.text "content", null: false
    t.boolean "posted_to_slack", default: false, null: false
    t.datetime "posted_to_slack_at"
    t.integer "entry_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "summary_date"], name: "index_standup_summaries_on_team_id_and_summary_date", unique: true
    t.index ["team_id"], name: "index_standup_summaries_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "slack_webhook_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "email"], name: "index_users_on_team_id_and_email", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "standup_entries", "teams"
  add_foreign_key "standup_entries", "users"
  add_foreign_key "standup_summaries", "teams"
  add_foreign_key "users", "teams"
end

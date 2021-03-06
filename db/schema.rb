# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080924024430) do

  create_table "boat_models", :force => true do |t|
    t.string "name"
    t.string "notes"
  end

  create_table "boat_owners", :force => true do |t|
    t.string "name"
    t.string "notes"
  end

  create_table "boats", :force => true do |t|
    t.string  "name"
    t.string  "notes"
    t.integer "boat_model_id"
    t.integer "boat_owner_id"
  end

  create_table "log_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "departed_at"
    t.datetime "arrived_at"
    t.string   "origin"
    t.string   "destination"
    t.integer  "days_onboard"
    t.integer  "night_hours"
    t.text     "notes"
    t.integer  "user_id"
    t.integer  "boat_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string "openid_identifier"
    t.string "nickname"
    t.string "fullname"
    t.string "email"
  end

end

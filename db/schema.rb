# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150120174813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "github_users", force: :cascade do |t|
    t.string   "github_username", null: false
    t.string   "secret",          null: false
    t.string   "access_token",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "pull_requests", force: :cascade do |t|
    t.integer  "github_user_id",                  null: false
    t.integer  "repository_id",                   null: false
    t.string   "url",                             null: false
    t.string   "title",                           null: false
    t.text     "body"
    t.string   "status",         default: "open"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "url",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "github_user_id"
    t.integer  "pull_request_id"
    t.string   "status",          default: "to_review"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

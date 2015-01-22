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

  create_table "github_users", force: :cascade do |t|
    t.string   "github_username", limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "pull_requests", force: :cascade do |t|
    t.integer  "github_user_id", limit: 4,                      null: false
    t.integer  "repository_id",  limit: 4,                      null: false
    t.string   "url",            limit: 255,                    null: false
    t.string   "title",          limit: 255,                    null: false
    t.text     "body",           limit: 65535
    t.string   "status",         limit: 255,   default: "open"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", force: :cascade do |t|
    t.integer  "github_id",  limit: 4,   null: false
    t.string   "name",       limit: 255, null: false
    t.string   "url",        limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "reviewers", force: :cascade do |t|
    t.integer  "github_user_id",  limit: 4
    t.integer  "pull_request_id", limit: 4
    t.string   "status",          limit: 255, default: "to_review"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

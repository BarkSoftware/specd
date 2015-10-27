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

ActiveRecord::Schema.define(version: 20150722033357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collaborators", force: true do |t|
    t.integer  "project_id"
    t.string   "email"
    t.string   "invite_token"
    t.boolean  "confirmed"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "columns", force: true do |t|
    t.string   "title"
    t.integer  "project_id"
    t.integer  "ordinal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_progress"
    t.boolean  "closed"
    t.boolean  "issues_start_here"
    t.boolean  "todo"
  end

  add_index "columns", ["project_id"], name: "index_columns_on_project_id", using: :btree

  create_table "issues", force: true do |t|
    t.integer  "project_id"
    t.integer  "number"
    t.decimal  "estimate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "issue_type"
    t.integer  "kanban_sort"
    t.string   "kanban_status"
    t.integer  "column_id"
  end

  add_index "issues", ["column_id"], name: "index_issues_on_column_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "github_repository"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived"
    t.string   "estimate_type"
    t.string   "cost_method"
    t.string   "webhook_secret"
  end

  add_index "projects", ["webhook_secret"], name: "index_projects_on_webhook_secret", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "provider",            default: "", null: false
    t.string   "uid",                              null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "encrypted_password"
    t.string   "full_name"
    t.string   "image"
    t.string   "nickname"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end

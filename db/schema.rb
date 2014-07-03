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

ActiveRecord::Schema.define(version: 20140609072422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "data"
    t.datetime "created_at"
    t.integer  "item_id"
    t.string   "action"
    t.integer  "task_id"
  end

  create_table "project_monthly_incomes", force: true do |t|
    t.integer  "project_id"
    t.integer  "income_per_month"
    t.date     "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "site"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "description"
    t.time     "real_time"
    t.string   "status"
    t.string   "specialization"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "full_description"
    t.time     "deadline"
    t.string   "priority"
    t.datetime "started_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "password"
    t.string   "email"
    t.string   "role"
    t.integer  "salary_per_hour"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "level"
    t.string   "active"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end

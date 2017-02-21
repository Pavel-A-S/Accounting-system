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

ActiveRecord::Schema.define(version: 20161027172034) do

  create_table "events", force: :cascade do |t|
    t.text     "state"
    t.integer  "user_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "note"
    t.string   "project_id"
    t.string   "ccy"
    t.string   "amount"
    t.text     "subject"
  end

  add_index "events", ["order_id"], name: "index_events_on_order_id"
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "exchange_files", force: :cascade do |t|
    t.string   "path"
    t.integer  "exchange_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "exchange_files", ["exchange_id"], name: "index_exchange_files_on_exchange_id"

  create_table "exchanges", force: :cascade do |t|
    t.integer  "from_currency"
    t.integer  "to_currency"
    t.decimal  "amount_before",   precision: 14, scale: 2
    t.decimal  "amount_after",    precision: 14, scale: 2
    t.decimal  "conversion_rate", precision: 14, scale: 4
    t.text     "description"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "date"
    t.integer  "user_id"
    t.integer  "conversion_type"
  end

  create_table "expenditures", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "incomes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "project_id"
  end

  create_table "order_files", force: :cascade do |t|
    t.string   "path"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "order_files", ["order_id"], name: "index_order_files_on_order_id"

  create_table "orders", force: :cascade do |t|
    t.text     "subject"
    t.string   "ccy"
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "state"
    t.integer  "project_id"
    t.integer  "sent_to"
    t.integer  "expenditure_id"
    t.boolean  "handled"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.integer  "code"
    t.decimal  "value",      precision: 10, scale: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "record_files", force: :cascade do |t|
    t.string   "path"
    t.integer  "record_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "record_files", ["record_id"], name: "index_record_files_on_record_id"

  create_table "records", force: :cascade do |t|
    t.integer  "source_id"
    t.datetime "date"
    t.integer  "ccy"
    t.decimal  "amount",         precision: 14, scale: 2
    t.text     "description"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "record_type"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "expenditure_id"
  end

  create_table "rights", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

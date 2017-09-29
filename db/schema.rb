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

ActiveRecord::Schema.define(version: 20170106022253) do

  create_table "donations", force: true do |t|
    t.integer  "donor_id"
    t.integer  "user_id"
    t.decimal  "amount"
    t.date     "date"
    t.string   "comment"
    t.boolean  "thanked"
    t.boolean  "match"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "donations", ["donor_id"], name: "index_donations_on_donor_id"
  add_index "donations", ["user_id"], name: "index_donations_on_user_id"

  create_table "donors", force: true do |t|
    t.integer  "user_id"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "solicitation"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "relationship"
    t.string   "singer"
    t.string   "comment"
    t.boolean  "anonymous"
    t.boolean  "update_address"
    t.boolean  "do_not_contact"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "donors", ["user_id"], name: "index_donors_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end

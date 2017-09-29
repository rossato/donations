class LoadSchema < ActiveRecord::Migration
  def change
    create_table "donations", force: :cascade do |t|
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

    create_table "donors", force: :cascade do |t|
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

    create_table "users", force: :cascade do |t|
      t.string   "name"
      t.string   "password_digest"
      t.boolean  "admin"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end
  end
end

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

ActiveRecord::Schema[8.1].define(version: 2025_01_04_042644) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "amounts", force: :cascade do |t|
    t.integer "amount_in_base_units"
    t.datetime "created_at", null: false
    t.string "currency", default: "AUD"
    t.bigint "distribution_id", null: false
    t.datetime "updated_at", null: false
    t.index ["distribution_id"], name: "index_amounts_on_distribution_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.integer "amount_in_base_units"
    t.datetime "created_at", null: false
    t.string "currency", default: "AUD"
    t.integer "fees_in_base_units", default: 0
    t.bigint "member_id"
    t.string "transaction_identifier"
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_contributions_on_member_id"
    t.index ["transaction_identifier"], name: "index_contributions_on_transaction_identifier", unique: true
  end

  create_table "distributions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_distributions_on_name", unique: true
  end

  create_table "dividends", force: :cascade do |t|
    t.bigint "amount_id"
    t.datetime "created_at", null: false
    t.bigint "member_id"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["amount_id"], name: "index_dividends_on_amount_id"
    t.index ["member_id"], name: "index_dividends_on_member_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "amount_in_base_units"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "AUD"
    t.string "name"
    t.string "paypalme_handle", limit: 1024
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["paypalme_handle"], name: "index_members_on_paypalme_handle", unique: true
    t.index ["user_id"], name: "index_members_on_user_id", unique: true
  end

  create_table "notification_preferences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true
    t.bigint "member_id", null: false
    t.integer "notification_name", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_notification_preferences_on_member_id"
    t.index ["notification_name", "member_id"], name: "idx_on_notification_name_member_id_d786d07610", unique: true
  end

  create_table "pay_outs", force: :cascade do |t|
    t.integer "amount_in_base_units", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "AUD"
    t.bigint "dividend_id", null: false
    t.integer "fees_in_base_units", default: 0
    t.string "transaction_identifier", null: false
    t.datetime "updated_at", null: false
    t.index ["dividend_id"], name: "index_pay_outs_on_dividend_id"
    t.index ["transaction_identifier"], name: "index_pay_outs_on_transaction_identifier", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "amounts", "distributions"
  add_foreign_key "contributions", "members"
  add_foreign_key "dividends", "amounts"
  add_foreign_key "dividends", "members"
  add_foreign_key "members", "users"
  add_foreign_key "notification_preferences", "members"
  add_foreign_key "pay_outs", "dividends"
end

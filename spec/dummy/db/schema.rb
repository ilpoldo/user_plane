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

ActiveRecord::Schema.define(version: 20141026230208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_accounts", force: true do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_accounts", ["uid"], name: "index_user_accounts_on_uid", using: :btree

  create_table "user_identities_email_verifications", force: true do |t|
    t.string   "token"
    t.string   "type"
    t.integer  "email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_identities_email_verifications", ["email_id"], name: "index_user_identities_email_verifications_on_email_id", using: :btree

  create_table "user_identities_emails", force: true do |t|
    t.integer  "account_id"
    t.string   "address"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_identities_emails", ["address"], name: "index_user_identities_emails_on_address", using: :btree
  add_index "user_identities_emails", ["password_digest"], name: "index_user_identities_emails_on_password_digest", using: :btree

  create_table "user_identities_id_tokens", force: true do |t|
    t.string   "key"
    t.integer  "identity_id"
    t.string   "identity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_identities_id_tokens", ["identity_id"], name: "index_user_identities_id_tokens_on_identity_id", using: :btree
  add_index "user_identities_id_tokens", ["key"], name: "index_user_identities_id_tokens_on_key", using: :btree

  create_table "user_identities_o_auths", force: true do |t|
    t.integer  "account_id"
    t.string   "type"
    t.string   "uid"
    t.string   "handle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_identities_o_auths", ["handle"], name: "index_user_identities_o_auths_on_handle", using: :btree
  add_index "user_identities_o_auths", ["type"], name: "index_user_identities_o_auths_on_type", using: :btree

  create_table "user_sign_up_invites_invites", force: true do |t|
    t.integer  "stack_id"
    t.string   "code"
    t.string   "recipient"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sign_up_invites_stacks", force: true do |t|
    t.integer  "account_id"
    t.integer  "remaining_invites"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_suspensions", force: true do |t|
    t.string   "message"
    t.integer  "issuer_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_suspensions", ["account_id"], name: "index_user_suspensions_on_account_id", using: :btree
  add_index "user_suspensions", ["issuer_id"], name: "index_user_suspensions_on_issuer_id", using: :btree

end

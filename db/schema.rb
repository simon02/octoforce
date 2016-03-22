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

ActiveRecord::Schema.define(version: 20160322204020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "assets", force: :cascade do |t|
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
  end

  add_index "assets", ["user_id"], name: "index_assets_on_user_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "url"
    t.string   "status"
    t.boolean  "active",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "feeds", ["list_id"], name: "index_feeds_on_list_id", using: :btree
  add_index "feeds", ["url"], name: "index_feeds_on_url", using: :btree
  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "accesstoken"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "nickname"
    t.string   "image"
    t.string   "phone"
    t.string   "urls"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "refreshtoken"
    t.string   "secrettoken"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "next_post_id"
    t.string   "color"
  end

  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "last_scheduled"
    t.integer  "position"
    t.integer  "asset_id"
    t.string   "text"
  end

  add_index "posts", ["asset_id"], name: "index_posts_on_asset_id", using: :btree
  add_index "posts", ["list_id"], name: "index_posts_on_list_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "identity_id"
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "active",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "schedules", ["identity_id"], name: "index_schedules_on_identity_id", using: :btree
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "timeslots", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "schedule_id"
    t.integer  "day"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "offset"
  end

  add_index "timeslots", ["list_id"], name: "index_timeslots_on_list_id", using: :btree
  add_index "timeslots", ["schedule_id"], name: "index_timeslots_on_schedule_id", using: :btree

  create_table "updates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "timeslot_id"
    t.datetime "scheduled_at"
    t.boolean  "published",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "list_id"
    t.integer  "post_id"
    t.integer  "asset_id"
    t.string   "text"
    t.integer  "identity_id"
    t.string   "jid"
  end

  add_index "updates", ["asset_id"], name: "index_updates_on_asset_id", using: :btree
  add_index "updates", ["identity_id"], name: "index_updates_on_identity_id", using: :btree
  add_index "updates", ["list_id"], name: "index_updates_on_list_id", using: :btree
  add_index "updates", ["post_id"], name: "index_updates_on_post_id", using: :btree
  add_index "updates", ["timeslot_id"], name: "index_updates_on_timeslot_id", using: :btree
  add_index "updates", ["user_id"], name: "index_updates_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: ""
    t.string   "encrypted_password",               default: "",                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,                 null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                default: 0
    t.string   "bitly_login"
    t.string   "bitly_api_key"
    t.string   "timezone",                         default: "Europe/Brussels"
    t.integer  "onboarding_step",        limit: 2, default: 0
    t.boolean  "onboarding_active",                default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "assets", "users"
  add_foreign_key "feeds", "lists"
  add_foreign_key "feeds", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "lists", "users"
  add_foreign_key "posts", "assets"
  add_foreign_key "posts", "lists"
  add_foreign_key "posts", "users"
  add_foreign_key "schedules", "identities"
  add_foreign_key "schedules", "users"
  add_foreign_key "timeslots", "lists"
  add_foreign_key "timeslots", "schedules"
  add_foreign_key "updates", "assets"
  add_foreign_key "updates", "identities"
  add_foreign_key "updates", "lists"
  add_foreign_key "updates", "posts"
  add_foreign_key "updates", "timeslots"
  add_foreign_key "updates", "users"
end

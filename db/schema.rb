# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_27_134812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_media", comment: "広告媒体マスターテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "媒体名"
    t.bigint "company_id", null: false, comment: "企業ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_ad_media_on_company_id"
    t.index ["name", "company_id"], name: "index_ad_media_on_name_and_company_id", unique: true
  end

  create_table "categories", comment: "カテゴリマスターテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "カテゴリ名"
    t.bigint "company_id", null: false, comment: "企業ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_categories_on_company_id"
    t.index ["name", "company_id"], name: "index_categories_on_name_and_company_id", unique: true
  end

  create_table "clients", comment: "クライアントマスターテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "媒体名"
    t.bigint "company_id", null: false, comment: "企業ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_clients_on_company_id"
    t.index ["name", "company_id"], name: "index_clients_on_name_and_company_id", unique: true
  end

  create_table "companies", comment: "利用企業テーブル", force: :cascade do |t|
    t.string "name", comment: "企業名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "sql_conditions", comment: "検索条件テーブル", force: :cascade do |t|
    t.string "code", null: false, comment: "検索対象フックコード"
    t.text "condition", comment: "検索条件"
    t.bigint "user_id", null: false, comment: "アカウントID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sql_conditions_on_user_id"
  end

  create_table "users", comment: "ユーザーテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "氏名"
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.boolean "grader", default: false, null: false, comment: "採点者フラグ"
    t.boolean "administrator", default: false, null: false, comment: "管理者フラグ"
    t.bigint "company_id", null: false, comment: "企業ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "ad_media", "companies"
  add_foreign_key "categories", "companies"
  add_foreign_key "clients", "companies"
  add_foreign_key "sql_conditions", "users"
  add_foreign_key "users", "companies"
end
